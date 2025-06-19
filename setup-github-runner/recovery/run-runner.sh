#!/bin/bash
# Setup the GitHub runner with dynamic Docker socket group support

REPO_URL="$1"
RUNNER_TOKEN="$2"

if [[ -z "$REPO_URL" || -z "$RUNNER_TOKEN" ]]; then
  echo "Usage: ./run-runner.sh <REPO_URL> <RUNNER_TOKEN>"
  exit 1
fi

DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

# Build with GID injected as a build arg
docker build --build-arg DOCKER_GID=$DOCKER_GID -t oneshot-runner .

docker stop github-runner 2>/dev/null || true
docker rm github-runner 2>/dev/null || true

docker run -d \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e REPO_URL="$REPO_URL" \
  -e RUNNER_TOKEN="$RUNNER_TOKEN" \
  --name github-runner \
  --restart=always \
  fixedbackup

