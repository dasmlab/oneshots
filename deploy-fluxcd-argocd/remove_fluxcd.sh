#!/bin/bash
set -e

NAMESPACE="${1:-flux-system}"

echo "🧹 Removing FluxCD components from namespace: $NAMESPACE..."

echo "📦 Deleting Flux system manifests..."
kubectl delete kustomizations.kustomize.toolkit.fluxcd.io --all -n "$NAMESPACE" || true
kubectl delete gitrepositories.source.toolkit.fluxcd.io --all -n "$NAMESPACE" || true
#kubectl delete helmreleases.helm.toolkit.fluxcd.io --all -n "$NAMESPACE" || true
#kubectl delete helmrepositories.source.toolkit.fluxcd.io --all -n "$NAMESPACE" || true

#echo "🧼 Deleting namespace $NAMESPACE..."
#kubectl delete namespace "$NAMESPACE" || true

#echo "🗑️ Removing local flux CLI if installed..."
#if command -v flux >/dev/null; then
#  sudo rm -f $(which flux)
#  echo "✅ flux CLI removed"
#else
#  echo "ℹ️ flux CLI not found locally"
#fi

echo "✅ FluxCD cleanup complete."

