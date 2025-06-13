#!/bin/bash
set -euo pipefail

echo "[*] Stopping k3s..."
systemctl stop k3s || true

echo "[*] Uninstalling k3s and removing all traces..."
/usr/local/bin/k3s-uninstall.sh || true

echo "[*] Removing k3s data directories..."
rm -rf /etc/rancher /var/lib/rancher /var/lib/kubelet /var/lib/cni /opt/cni /var/log/pods
rm -rf /var/lib/containerd /var/lib/etcd /etc/cni /root/.kube

echo "[*] Removing MetalLB CRDs if any remain..."
rm -rf /var/lib/metallb

echo "[*] Cleaning up network interfaces (CNI)..."
ip link delete cni0 || true
ip link delete flannel.1 || true

echo "[✓] K3s and MetalLB have been fully removed. System is clean."

