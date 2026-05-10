#!/bin/bash

set -euo pipefail

name="${1}"
image="${2}"
registry="${3}"
registry_ca="${4}"

work_dir="${RUNNER_TEMP}/scothis/kind/${name}"
if [ -d  "${work_dir}" ] ; then
    echo "::error title=duplicate kind cluster::another cluster with the name \"${name}\" appears to be in use"
    exit 1
fi
mkdir -p "${work_dir}"

if [[ "${registry_ca}" != "" ]] ; then
  cp "${registry_ca}" "${work_dir}/ca.pem"
  docker build \
    -f $(dirname "$0")/Dockerfile \
    --build-arg name="${name}" \
    --build-arg registry="${registry}" \
    --build-arg image="${image}" \
    --build-arg ca="ca.pem" \
    -t "${image}-with-ca" \
    "${work_dir}"
  image="${image}-with-ca"
fi

cat <<EOF > "${work_dir}/kind.yaml"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: "${name}"
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
nodes:
- role: control-plane
  image: "${image}"
EOF

kind create cluster --name "${name}" --image "${image}" --wait 5m

if [[ "${registry}" != "" ]] ; then
  # Document the local registry
  # https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "${registry}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF
fi
