#!/bin/bash

set -euo pipefail

echo "Stopping cloud-provider-kind"
docker stop cloud-provider-kind

echo "##[group]cloud-provider-kind logs"
  docker logs cloud-provider-kind
echo "##[endgroup]"

docker rm cloud-provider-kind
