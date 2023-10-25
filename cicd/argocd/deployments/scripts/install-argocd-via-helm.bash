#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Helm chart repo: https://github.com/argoproj/argo-helm/tree/main
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo

helm upgrade argocd \
  argo/argo-cd \
  --install \
  --version 5.46.8 \
  --namespace argocd \
  --create-namespace \
  --wait \
  --values ../helm/overrides/argocd.yaml

