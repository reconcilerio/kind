#!/bin/bash

set -euo pipefail

name="${1}"
image="${2}"
registry="${3:-localhost}"
registry_ca="${4}"

work_dir="${RUNNER_TEMP}/scothis/kind/${name}"
cert_dir="${work_dir}/certs"
if [ -d  "${cert_dir}" ] ; then
    echo "::error title=duplicate kind cluster::another cluster with the name \"${name}\" appears to be in use"
    exit 1
fi
mkdir -p "${cert_dir}"

cat <<EOF > "${cert_dir}/hosts.toml"
server = "https://${registry}"

[host."https://${registry}"]
    capabilities = ["pull"]
EOF
if [[ "${registry_ca}" != "" ]] ; then
    echo "    ca = \"/etc/containerd/certs.d/${registry}/ca.pem\"" >> "${cert_dir}/hosts.toml"
    cp "${registry_ca}" "${cert_dir}/ca.pem"
fi


# create a cluster with the local registry enabled in containerd
cat <<EOF > "${work_dir}/kind.yaml"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
nodes:
- role: control-plane
  image: "${image}"
  extraMounts:
  - containerPath: "/etc/containerd/certs.d/${registry}"
    hostPath: "${cert_dir}"
EOF

kind create cluster "${name}" --config "${work_dir}/kind.yaml" --wait 5m
