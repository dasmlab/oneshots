#!/bin/bash
set -e

if [[ -z "$RUNNER_TOKEN" || -z "$REPO_URL" ]]; then
  echo "❌ Missing required env vars: RUNNER_TOKEN and REPO_URL"
  exit 1
fi

cd /runner

./config.sh \
  --unattended \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$(hostname)-container-runner" \
  --work "_work" \
  --labels "self-hosted,linux,container"

exec ./run.sh

