#!/bin/bash

set -euo pipefail

version="${1}"

echo "Starting cloud-provider-kind"
docker run -d --name cloud-provider-kind --network host -v /var/run/docker.sock:/var/run/docker.sock "registry.k8s.io/cloud-provider-kind/cloud-controller-manager:${version}"
