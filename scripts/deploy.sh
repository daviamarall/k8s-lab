#!/usr/bin/env bash
# Aplica um overlay (dev por padrao) no cluster atual.
set -euo pipefail

OVERLAY="${1:-dev}"

echo "Aplicando overlays/${OVERLAY}..."
kubectl apply -k "overlays/${OVERLAY}"

echo "Aguardando rollout..."
kubectl rollout status deployment/podinfo -n "podinfo-${OVERLAY}"
