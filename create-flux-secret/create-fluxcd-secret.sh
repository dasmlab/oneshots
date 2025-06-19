#!/bin/bash

GHCR_PAT=${DASMLAB_GHCR_PAT}
USERNAME="git"
TAR_NS="design-carousel-service-system"
echo "PAT (BAD):   $GHCR_PAT"
echo "USERNAME :  $USERNAME"
echo "NS : $TAR_NS"


kubectl create secret generic flux-github-auth \
  --namespace=$TAR_NS \
  --from-literal=username=$TAR_NS \
  --from-literal=password=$GHCR_PAT

