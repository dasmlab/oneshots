# 🧩 Oneshot Deploy Scripts for FluxCD & ArgoCD

This repo contains quick-start, atomic deploy scripts for **FluxCD** and **ArgoCD**, built for isolated and repeatable application onboarding into Kubernetes GitOps flows.

---

## 📦 Included Scripts

| Script                        | Purpose                                                |
|------------------------------|--------------------------------------------------------|
| `oneshot_deploy-fluxcd.sh`   | Deploy a GitRepository + Kustomization via FluxCD     |
| `add_fluxcd_repo.sh`         | Add another Git repo source to FluxCD                 |
| `oneshot_deploy-argocd.sh`   | Deploy an Application manifest into ArgoCD            |
| `add_argocd_repo.sh`         | Add another ArgoCD app linked to Git manifests        |

---

## ✅ Requirements

To use these scripts, ensure your environment has the following:

- `kubectl` installed and configured with a **valid kubeconfig**
- Access to a **working Kubernetes cluster**
- The target cluster should already have:
  - **FluxCD** installed (for FluxCD scripts)
  - **ArgoCD** installed (for ArgoCD scripts)
- Optional:
  - `helm` (if your manifests or cluster use Helm releases)
  - `terraform` (for additional IaC validation or steps)

---

## 🚀 Usage

### 🔧 FluxCD

```bash
# Deploy a Flux GitRepository + Kustomization
./oneshot_deploy-fluxcd.sh <repo-name> <repo-url> <repo-path> [namespace]
```

# Example:
./oneshot_deploy-fluxcd.sh dasmlab https://github.com/lmcdasm/dasmlab_live_cicd.git ./clusters/dasmlab-prod-1/dasmlab_home

# Add a repo to FluxCD (source only)
./add_fluxcd_repo.sh <repo-name> <repo-url> [namespace]

🎯 ArgoCD

```bash
# Deploy an ArgoCD Application
./oneshot_deploy-argocd.sh <app-name> <repo-url> <repo-path> [namespace]
```

# Example:
./oneshot_deploy-argocd.sh dasmlab-home https://github.com/lmcdasm/dasmlab_live_cicd.git clusters/dasmlab-prod-1/dasmlab_home

# 🧼 Notes

Each script prompts before applying generated manifests

Manifests are stored temporarily and cleaned up afterward

Defaults:

Namespace flux-system for FluxCD

Namespace argocd for ArgoCD

For contributions or questions, reach out to dasmlab.org
