#!/bin/bash
set -e

REPO_NAME="$1"
REPO_URL="$2"
REPO_PATH="$3"
NAMESPACE="${4:-flux-system}"

if [ -z "$REPO_NAME" ] || [ -z "$REPO_URL" ] || [ -z "$REPO_PATH" ]; then
  echo "Usage: ./oneshot_deploy-fluxcd.sh <repo-name> <repo-url> <repo-path> [namespace]"
  exit 1
fi

MANIFEST_NAME="${REPO_NAME}-${NAMESPACE}"

echo "🔍 Verifying kube context..."
kubectl get nodes > /dev/null || { echo "❌ Cannot access Kubernetes cluster."; exit 1; }

echo "🛠️ Checking optional tools..."
command -v helm >/dev/null && helm version || echo "Helm not installed"
command -v terraform >/dev/null && terraform version || echo "Terraform not installed"

echo "🔎 Checking if Flux is installed in namespace: $NAMESPACE"
if ! kubectl get pods -n "$NAMESPACE" 2>/dev/null | grep -q flux; then
  echo "📦 Flux not detected. Installing..."
  curl -s https://fluxcd.io/install.sh | sudo bash
  flux install --namespace="$NAMESPACE"
fi

echo "📝 Generating Flux manifest for GitRepository + Kustomization"
cat <<EOF > /tmp/flux-${MANIFEST_NAME}.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: ${MANIFEST_NAME}
  namespace: ${NAMESPACE}
spec:
  interval: 30s
  url: ${REPO_URL}
  ref:
    branch: main
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: ${MANIFEST_NAME}
  namespace: ${NAMESPACE}
spec:
  interval: 1m0s
  path: ${REPO_PATH}
  prune: true
  sourceRef:
    kind: GitRepository
    name: ${MANIFEST_NAME}
  targetNamespace: default
EOF

echo "----------------------------------------"
cat /tmp/flux-${MANIFEST_NAME}.yaml
echo "----------------------------------------"

read -p 'Apply this manifest? (yes/no): ' CONFIRM
if [[ "$CONFIRM" == "yes" ]]; then
  echo "🚀 Applying manifest..."
  kubectl apply -f /tmp/flux-${MANIFEST_NAME}.yaml
  echo "✅ Done."
else
  echo "❌ Aborted."
fi

rm -f /tmp/flux-${MANIFEST_NAME}.yaml

