#!/bin/bash

set -euo pipefail

name="${1}"

kind delete cluster "${name}"
