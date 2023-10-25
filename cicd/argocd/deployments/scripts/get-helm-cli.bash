#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

desired_version=${1:-v3.13.0}
cd /tmp/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo bash get_helm.sh --version "${desired_version}"
rm get_helm.sh

echo "helm installed! Version:"
helm version
