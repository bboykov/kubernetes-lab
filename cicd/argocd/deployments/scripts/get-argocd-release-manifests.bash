#!/usr/bin/env bash
### Download and place given argocd release manifests
### Usage:
### Execute from the scripts directory and optionally provide version:
### ./get-argocd-release-manifests.bash [v1.8.4]

set -euo pipefail

argocd_version=${1:-v2.8.4}
base_directory="../kustomize/base"

### Non-HA Release
release_url="https://raw.githubusercontent.com/argoproj/argo-cd/${argocd_version}/manifests/install.yaml"
### HA Release
# release_url="https://raw.githubusercontent.com/argoproj/argo-cd/${argocd_version}/manifests/ha/install.yaml"

wget "${release_url}" -O "${base_directory}/install.yaml"
