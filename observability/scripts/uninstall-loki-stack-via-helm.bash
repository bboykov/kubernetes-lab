#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

kubie ctx kind-local-k8s-lab-kind-cluster

helm uninstall loki \
  --namespace loki-stack

helm uninstall promtail \
  --namespace loki-stack
