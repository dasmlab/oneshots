#!/bin/bash
set -e

REPO_NAME="$1"
REPO_URL="$2"
NAMESPACE="${3:-flux-system}"

if [ -z "$REPO_NAME" ] || [ -z "$REPO_URL" ]; then
  echo "Usage: ./add_fluxcd_repo.sh <repo-name> <repo-url> [namespace]"
  exit 1
fi

echo "📡 Checking connectivity to the cluster..."
kubectl get pods -n "$NAMESPACE" > /dev/null || { echo "❌ Cannot access namespace $NAMESPACE."; exit 1; }

echo "📦 Adding Flux source for $REPO_NAME from $REPO_URL"
flux create source git "$REPO_NAME" \
  --url="$REPO_URL" \
  --branch=main \
  --interval=1m \
  --namespace="$NAMESPACE"

