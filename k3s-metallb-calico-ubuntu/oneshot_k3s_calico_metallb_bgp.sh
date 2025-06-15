#!/bin/bash
# (c) dasmlab
set -euo pipefail

# CONFIG
K3S_VERSION="v1.29.4+k3s1"
KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
METALLB_VERSION="v0.14.5"
CALICO_VERSION="v3.27.0"
ASN_LOCAL="65001"
ASN_PEER="65999"
PEER_IP="192.168.19.1"
MY_BGP_IP="192.168.19.10"
RANGE_START="10.10.1.220"
RANGE_END="10.10.1.230"
NIC_PRIMARY="ens32"
NIC_BGP="ens36"

echo "[*] Installing K3s (${K3S_VERSION})..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$K3S_VERSION sh -

echo "[*] Exporting kubeconfig for root..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "[*] Waiting for K3s to be ready..."
sleep 10
kubectl wait --for=condition=Ready node --all --timeout=90s

echo "[*] Installing Calico ${CALICO_VERSION}  CRDs"
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml

echo "[*] Installing MetalLB ${METALLB_VERSION} CRDs..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml


echo "[*] Waiting for MetalLB controller to be ready..."
kubectl wait --namespace metallb-system --for=condition=Available deployment/controller --timeout=120s

echo "[*] Creating MetalLB IPAddressPool and BGP Configuration..."

cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: bgp-pool
  namespace: metallb-system
spec:
  addresses:
  - ${RANGE_START}-${RANGE_END}
---
apiVersion: metallb.io/v1beta1
kind: BGPPeer
metadata:
  name: peer-on-192-168
  namespace: metallb-system
spec:
  peerAddress: ${PEER_IP}
  peerASN: ${ASN_PEER}
  myASN: ${ASN_LOCAL}
  sourceAddress: ${MY_BGP_IP}
---
apiVersion: metallb.io/v1beta1
kind: BGPAdvertisement
metadata:
  name: advert-all
  namespace: metallb-system
spec:
  ipAddressPools:
  - bgp-pool
EOF

echo "[✓] K3s with MetalLB in BGP mode is fully configured."

