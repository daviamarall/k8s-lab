#!/usr/bin/env bash
# Cria um cluster local com kind e instala o ingress-nginx.
set -euo pipefail

CLUSTER_NAME="k8s-lab"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Cluster '${CLUSTER_NAME}' ja existe."
else
  echo "Criando cluster '${CLUSTER_NAME}'..."
  kind create cluster --config kind/kind-config.yaml
fi

echo "Instalando ingress-nginx..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "Aguardando o ingress controller ficar pronto..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo "Pronto. Use: kubectl apply -k overlays/dev"
