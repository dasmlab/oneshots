#!/bin/bash

GHCR_PAT=${DASMLAB_GHCR_PAT}
echo "DASMLAB_GHCR_PATH (first 6): " + ${DASMLAB_GHCR_PAT}[:8]
kubectl create secret docker-registry dasmlab-ghcr-pull \
  --docker-server=ghcr.io \
  --docker-username=dasmlab \
  --docker-password=${GHCR_PAT} \
  --docker-email=dasmlab-bot@dasmlab.org \
  -n whatsnew-service-system

