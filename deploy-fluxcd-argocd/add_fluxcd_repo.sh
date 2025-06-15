#!/bin/bash
set -e

# Usage: ./add_fluxcd_repo.sh <cluster_name> <app_name> [namespace] [repo_url]
# Defaults:
#   NAMESPACE = <app_name>-system
#   REPO_URL = https://github.com/lmcdasm/dasmlab-live-cicd

CLUSTER_NAME="$1"
APP_NAME="$2"
NAMESPACE="${3:-${APP_NAME}-system}"
REPO_URL="${4:-https://github.com/lmcdasm/dasmlab-live-cicd.git}"
PAT="${DASMLAB_PAT}"

echo "PAT(BAD): $PAT"

if [ -z "$CLUSTER_NAME" ] || [ -z "$APP_NAME" ]; then
  echo "Usage: ./add_fluxcd_repo.sh <cluster_name> <app_name> [namespace] [repo_url]"
  exit 1
fi

REPO_PATH="./clusters/${CLUSTER_NAME}/${APP_NAME}/live"
REPO_NAME="${APP_NAME}"

echo "📡 Checking connectivity to the cluster and namespace: $NAMESPACE"
kubectl get ns "$NAMESPACE" >/dev/null 2>&1 || kubectl create ns "$NAMESPACE"

echo "📦 Adding Flux source for $REPO_NAME from $REPO_URL"
flux create source git "$REPO_NAME" \
  --url="$REPO_URL" \
  --branch=main \
  --interval=30s \
  --namespace="$NAMESPACE" \
  --secret-ref=flux-github-auth

echo "🧩 Creating Flux Kustomization for $REPO_NAME (path: $REPO_PATH)"
flux create kustomization "$REPO_NAME" \
  --source=GitRepository/"$REPO_NAME" \
  --path="$REPO_PATH" \
  --prune=true \
  --interval=30s \
  --namespace="$NAMESPACE" 

echo "✅ FluxCD is now watching $REPO_URL at $REPO_PATH in namespace $NAMESPACE"

