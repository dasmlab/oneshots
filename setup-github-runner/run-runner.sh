#!/bin/bash

# Example:
# REPO_URL=https://github.com/myorg/myrepo
# TOKEN=generated-from-github-ui

REPO_URL="$1"
RUNNER_TOKEN="$2"

if [[ -z "$REPO_URL" || -z "$RUNNER_TOKEN" ]]; then
  echo "Usage: ./run-runner.sh <REPO_URL> <RUNNER_TOKEN>"
  exit 1
fi

docker build -t oneshot-runner .

docker run -d \
  -e REPO_URL="$REPO_URL" \
  -e RUNNER_TOKEN="$RUNNER_TOKEN" \
  --name github-runner \
  --restart=always \
  oneshot-runner

