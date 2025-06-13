# OneShot K3s + MetalLB (BGP Mode) Setup

This script automates the setup of a **K3s cluster** with **MetalLB** configured for **BGP mode** on **Ubuntu 24.04**.

---

## Deployment Overview

![K3s + MetalLB Deployment Overview](assets/k3s_metallb_simple_layout.png)


---

## 🧰 Requirements

- Ubuntu 24.04 host
- Two NICs:
  - `ens32` (Main NIC): `10.10.1.120/16`
  - `ens36` (BGP NIC): `192.168.19.10/24`
- A reachable BGP peer at `192.168.19.1` (ASN `65999`)
  - Change the values in the script to match your layout
- Outbound internet access for pulling K3s and MetalLB components
- Root or sudo privileges

---

## 🧪 What It Does

1. Installs **K3s** (v1.29.4).
2. Installs **MetalLB** and configures:
   - **BGP mode** with:
     - Local ASN: `65001`
     - Peer ASN: `65999`
     - Peer IP: `192.168.19.1`
     - Source IP: `192.168.19.10`
   - IP Pool: `10.10.1.220` to `10.10.1.230` (/32s)
3. Applies all CRDs and configurations.

---

## 🚀 Usage

```bash
chmod +x oneshot_k3s_metallb_bgp.sh
sudo ./oneshot_k3s_metallb_bgp.sh

To Remove:

```bash
chmod +x oneshot_delete_k3s_metallb_bgp.sh
sudo ./oneshot_delete_k3s_metallb_bgp.sh
