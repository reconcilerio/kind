#!/bin/bash

set -euo pipefail

work_dir="${RUNNER_TEMP}/reconcilerio/kind/cloud-provider-kind"

echo "Stopping cloud-provider-kind"
PID=$(cat "${work_dir}/cloud-provider-kind.pid")
kill ${PID}
timeout 30 tail --pid=${PID} -f /dev/null || kill -9 ${PID}

echo "##[group]cloud-provider-kind logs"
  cat "${work_dir}/cloud-provider-kind.log"
echo "##[endgroup]"

rm -rfv "${work_dir}"
