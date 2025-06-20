# One Shots

There are lots of times when you need to repeat things. Stand up a runner, a oci-registry, a git repo, etc, etc.

The folders in this repo contain simple one-shots (bash scripts mostly and instructions) to run common day things on Ubuntu.


## List of One Shots

- **setup-github-runner**  - This sets up a simple docker container to run a github.com runner on  your local machine. This builds with the .NET deps, and in DockerInDocker mode

- **k3s-metallb-ubuntu** - This deployes a k3s (Rancher) cluster on a Ubuntu OS in BGP mode (with MetalLB CNI).

- **install-helm** - Simple latest helm install script 

- **install-terraform** - Simple latest Terraform install script

- **deploy-fluxcd-argocd** - FluxCD and ArgoCD Reconciler installations scripts

- **create-flux-secret** - Create a FluxCD secret for use on a Cluster 

- **create-registry-secret** -  Create a Dockerconfig.json Registry Secret

- **deploy-keycloak-k8s** - Setup an instance of **Keyclock** on  your K8s Cluster

- **install-aws-cli** - Install AWS CLI and Assumes STS Role setup script

- **install-circle-ci-runner** - Install K8s or Docker-In-Docker **CircleCI** Runner

- **output-bearer-jwt** - A simple script to fetch out your JWT Bearer token


