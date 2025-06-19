#!/bin/bash
#
#  This script deploys CircleCI to a target k8s cluster.
#
#  Requires/Assumes: you have Kubeconfig/context to your cluster, HELM installed and all the standard trappings

echo "REQUIRED! - Ensure you update values.yaml with your Organization/Resource Class and Token before you run this or it will fail"


# Install Helm Repo, Update and create NS
helm repo add container-agent https://packagecloud.io/circleci/container-agent/helm
helm repo update
kubectl create namespace circleci

# Deploy Conatiner-Agent (circle-ci HElm pkg)
#
helm install container-agent container-agent/container-agent -n circleci -f values.yaml


