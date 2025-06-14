#!/bin/bash
# Setup the github runner, note: this is modifed for a Docker In Docker style setup (check the dockerfile)

REPO_URL="$1"
RUNNER_TOKEN="$2"

if [[ -z "$REPO_URL" || -z "$RUNNER_TOKEN" ]]; then
  echo "Usage: ./run-runner.sh <REPO_URL> <RUNNER_TOKEN>"
  exit 1
fi

docker build -t oneshot-runner .

docker stop github-runner
docker rm github-runner

docker run -d \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e REPO_URL="$REPO_URL" \
  -e RUNNER_TOKEN="$RUNNER_TOKEN" \
  --name github-runner \
  --restart=always \
  oneshot-runner

