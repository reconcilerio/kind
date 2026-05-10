#!/bin/bash

set -euo pipefail

name="${1}"

work_dir="${RUNNER_TEMP}/scothis/kind/${name}"

kind delete cluster --name "${name}"
rm -rfv "${work_dir}"
