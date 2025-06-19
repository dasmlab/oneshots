#!/bin/bash

set -e

NAMESPACE=${1:-keycloak-system}
RELEASE="keycloak"
HELM_REPO="https://charts.bitnami.com/bitnami"
FQDN="keycloak.dasmlab.org"
KEYCLOAK_LB_IP="192.168.19.155"

echo "Creating namespace: $NAMESPACE"
kubectl create ns "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "Adding Bitnami Helm repo (if not exists)"
helm repo add bitnami $HELM_REPO || true
helm repo update

echo "Installing Keycloak via Helm (MetalLB LoadBalancer at $KEYCLOAK_LB_IP)"
helm upgrade --install $RELEASE bitnami/keycloak \
  --namespace $NAMESPACE \
  --set auth.adminUser=admin \
  --set auth.adminPassword=changeme123 \
  --set proxy=edge \
  --set service.type=LoadBalancer \
  --set service.loadBalancerIP=$KEYCLOAK_LB_IP \
  --set http.enabled=true \
  --set ingress.enabled=false \
  --wait

echo
echo "================================================================="
echo "Keycloak deployed!"
echo "  - Admin username: admin"
echo "  - Admin password: changeme123"
echo "  - Service LB IP:  $KEYCLOAK_LB_IP"
echo "  - FQDN:           $FQDN"
echo
echo "EXTERNAL (north) traffic should be SSL-terminated by HAProxy and"
echo "then forwarded (HTTP) to $KEYCLOAK_LB_IP:8080"
echo
echo "IMPORTANT: Change admin password after first login!"
echo "Visit https://$FQDN (via HAProxy) to access Keycloak Admin UI."
echo "================================================================="

