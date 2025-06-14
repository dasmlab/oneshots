#!/bin/bash
set -e

APP_NAME="$1"
REPO_URL="$2"
MANIFEST_PATH="$3"
NAMESPACE="${4:-argocd}"

if [ -z "$APP_NAME" ] || [ -z "$REPO_URL" ] || [ -z "$MANIFEST_PATH" ]; then
  echo "Usage: ./add_argocd_repo.sh <app-name> <repo-url> <path-within-repo> [namespace]"
  exit 1
fi

echo "🔍 Verifying ArgoCD namespace access..."
kubectl get pods -n "$NAMESPACE" > /dev/null || { echo "❌ Cannot access namespace $NAMESPACE."; exit 1; }

echo "📦 Creating ArgoCD application for $APP_NAME"
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $APP_NAME
spec:
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: $REPO_URL
    targetRevision: HEAD
    path: $MANIFEST_PATH
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

