#!/bin/bash

set -euo pipefail

name="${1}"
image="${2}"
registry="${3}"
registry_ca="${4}"

work_dir="${RUNNER_TEMP}/scothis/kind/${name}"
cert_dir="${work_dir}/certs"
if [ -d  "${work_dir}" ] ; then
    echo "::error title=duplicate kind cluster::another cluster with the name \"${name}\" appears to be in use"
    exit 1
fi

if [[ "${registry}" != "" ]] ; then
  mkdir -p "${cert_dir}"

  if [[ "${registry_ca}" != "" ]] ; then
    cp "${registry_ca}" "${cert_dir}/ca.pem"
    echo "##[group]Using CA"
      cat "${cert_dir}/ca.pem"
    echo "##[endgroup]"
  else
    touch "${cert_dir}/ca.pem"
  fi

  # define containerd host config for registry
  cat <<EOF > "${cert_dir}/hosts.toml"
server = "https://${registry}"

[host."https://${registry}"]
    capabilities = ["pull", "resolve"]
EOF
  if [[ "${registry_ca}" != "" ]] ; then
    cat <<EOF > "${cert_dir}/hosts.toml"
    ca = "/etc/containerd/certs.d/${registry}/ca.pem"
EOF
  fi

  echo "##[group]Using hosts"
    cat "${cert_dir}/hosts.toml"
  echo "##[endgroup]"
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
if [[ "${registry_ca}" != "" ]] ; then
  cat <<EOF > "${work_dir}/kind.yaml"
  extraMounts:
  - containerPath: /etc/containerd/certs.d/${registry}
    hostPath: ${cert_dir}
EOF
fi
echo "##[group]Using kind config"
  cat "${work_dir}/kind.yaml"
echo "##[endgroup]"

echo "##[group]Starting cluster"
  kind create cluster --config "${work_dir}/kind.yaml" --wait 5m
echo "##[endgroup]"

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
