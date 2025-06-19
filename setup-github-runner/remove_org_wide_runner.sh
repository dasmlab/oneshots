#!/bin/bash

# Usage: ./remove-runner.sh <owner/repo>
# Example: ./remove-runner.sh dasmlab/whatsnew-service

REPO="$1"

if [ -z "$REPO" ]; then
  echo "Usage: $0 <owner/repo>"
  exit 1
fi

RUNNER_NAME="runner-$(echo $REPO | tr '/' '-')"
DEST_DIR="/runner/$RUNNER_NAME"

if [ ! -d "$DEST_DIR" ]; then
  echo "Runner dir not found: $DEST_DIR"
  exit 1
fi

cd "$DEST_DIR"
./config.sh remove || true
rm -rf "$DEST_DIR"

echo "🧹 Runner '$RUNNER_NAME' removed."

