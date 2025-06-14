#!/bin/bash
set -e

APP_NAME="$1"
REPO_URL="$2"
REPO_PATH="$3"
NAMESPACE="${4:-argocd}"

if [ -z "$APP_NAME" ] || [ -z "$REPO_URL" ] || [ -z "$REPO_PATH" ]; then
  echo "Usage: ./oneshot_deploy-argocd.sh <app-name> <repo-url> <repo-path> [namespace]"
  exit 1
fi

echo "🔍 Verifying kube context..."
kubectl get nodes > /dev/null || { echo "❌ Cannot access Kubernetes cluster."; exit 1; }

echo "🛠️ Checking optional tools..."
command -v helm >/dev/null && helm version || echo "Helm not installed"
command -v terraform >/dev/null && terraform version || echo "Terraform not installed"

echo "🔎 Checking if ArgoCD is installed in namespace: $NAMESPACE"
if ! kubectl get pods -n "$NAMESPACE" 2>/dev/null | grep -q argocd-server; then
  echo "📦 ArgoCD not detected in $NAMESPACE. You must install it before proceeding."
  exit 1
fi

echo "📝 Generating ArgoCD Application manifest"
cat <<EOF > /tmp/argocd-${APP_NAME}.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${APP_NAME}
  namespace: ${NAMESPACE}
spec:
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: ${REPO_URL}
    targetRevision: HEAD
    path: ${REPO_PATH}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

echo "----------------------------------------"
cat /tmp/argocd-${APP_NAME}.yaml
echo "----------------------------------------"

read -p 'Apply this manifest? (yes/no): ' CONFIRM
if [[ "$CONFIRM" == "yes" ]]; then
  echo "🚀 Applying manifest..."
  kubectl apply -f /tmp/argocd-${APP_NAME}.yaml
  echo "✅ Done."
else
  echo "❌ Aborted."
fi

rm -f /tmp/argocd-${APP_NAME}.yaml

