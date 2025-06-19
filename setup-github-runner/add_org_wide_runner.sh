#!/bin/bash

# Usage: ./add-runner.sh <owner/repo> <registration_token>
# Example: ./add-runner.sh dasmlab/whatsnew-service ABC123TOKEN

set -e

REPO="$1"
TOKEN="$2"

if [ -z "$REPO" ] || [ -z "$TOKEN" ]; then
  echo "Usage: $0 <owner/repo> <registration_token>"
  exit 1
fi

# Derive runner name and work directory
RUNNER_NAME="runner-$(echo $REPO | tr '/' '-')"
WORK_DIR="_work_$(echo $REPO | tr '/' '_')"
DEST_DIR="/runner/$RUNNER_NAME"

# Check if already registered
if [ -d "$DEST_DIR" ]; then
  echo "Runner directory already exists: $DEST_DIR"
  echo "If you want to re-register, remove it first."
  exit 1
fi

# Create and populate
mkdir -p "$DEST_DIR"
cp -r /runner/* "$DEST_DIR"

# Register the new runner
cd "$DEST_DIR"

./config.sh \
  --url "https://github.com/$REPO" \
  --token "$TOKEN" \
  --name "$RUNNER_NAME" \
  --work "$WORK_DIR" \
  --unattended

# Launch the runner
nohup ./run.sh > "$DEST_DIR/nohup.out" 2>&1 &
echo "✅ Runner '$RUNNER_NAME' registered and started successfully."


