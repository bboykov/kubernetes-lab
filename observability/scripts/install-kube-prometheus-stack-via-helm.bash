#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

kubie ctx kind-local-k8s-lab-kind-cluster

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update prometheus-community

helm upgrade kps \
  prometheus-community/kube-prometheus-stack \
  --install \
  --version 51.4.0 \
  --namespace kps \
  --create-namespace \
  --wait \
  --values ../helm/overrides/kps.yaml
