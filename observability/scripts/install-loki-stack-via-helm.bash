#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

kubie ctx kind-local-k8s-lab-kind-cluster

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update grafana


helm upgrade loki grafana/loki \
  --install \
  --version 5.36.1 \
  --namespace loki-stack \
  --create-namespace \
  --values ../helm/overrides/loki.yaml

helm upgrade promtail grafana/promtail \
  --install \
  --version 6.15.3 \
  --namespace loki-stack \
  --create-namespace \
  --values ../helm/overrides/promtail.yaml

