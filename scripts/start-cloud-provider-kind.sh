#!/bin/bash

set -euo pipefail

work_dir="${RUNNER_TEMP}/reconcilerio/kind/cloud-provider-kind"
if [ -d  "${work_dir}" ] ; then
    echo "::error title=duplicate cloud-provider-kind::another instance of cloud-provider-kind appears to be running"
    exit 1
fi

echo "Starting cloud-provider-kind"
cloud-provider-kind > "${work_dir}/cloud-provider-kind.log" 2>&1 &
PID=$!
echo "${PID}" > cloud-provider-kind.pid
