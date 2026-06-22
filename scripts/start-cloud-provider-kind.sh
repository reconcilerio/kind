#!/bin/bash

set -euo pipefail

cloud_provider_kind="${1}"

work_dir="${RUNNER_TEMP}/reconcilerio/kind/cloud-provider-kind"
if [ -d  "${work_dir}" ] ; then
    echo "::error title=duplicate cloud-provider-kind::another instance of cloud-provider-kind appears to be running"
    exit 1
fi
mkdir -p "${work_dir}"

echo "Starting cloud-provider-kind"
"${cloud_provider_kind}" > "${work_dir}/cloud-provider-kind.log" 2>&1 &
PID=$!
echo "${PID}" > "${work_dir}/cloud-provider-kind.pid"
