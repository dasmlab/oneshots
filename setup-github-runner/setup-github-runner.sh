#!/bin/bash

# OneShot GitHub Runner Setup Script

set -e

# Required: set these before running
GITHUB_OWNER="lmcdasm"     # e.g., dasmlab
GITHUB_REPO="oneshots"             # e.g., dasmlab-home
RUNNER_NAME="$(hostname)-runner"
RUNNER_WORK_DIR="_work"



# Optional: runner labels
RUNNER_LABELS="self-hosted,Linux,X64,oneshot"


# With this check
if [[ -z "$GITHUB_PAT" ]]; then
  echo "❌ GITHUB_PAT not set. Please export it or pass it inline."
  exit 1
fi


# Check if required env vars are set
if [[  -z "$GITHUB_OWNER" || -z "$GITHUB_REPO" ]]; then
  echo "❌ Please set GITHUB_PAT, GITHUB_OWNER, and GITHUB_REPO in the script."
  exit 1
fi

echo "📦 Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y curl jq tar

echo "📁 Creating runner directory..."
mkdir -p actions-runner && cd actions-runner

echo "⬇️ Downloading latest GitHub runner..."
LATEST_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest \
  | jq -r '.assets[] | select(.name | test("linux-x64")) | .browser_download_url')

curl -O -L "$LATEST_URL"
tar xzf ./actions-runner-linux-x64-*.tar.gz

echo "🔑 Getting registration token from GitHub..."
REG_TOKEN=$(curl -s -X POST \
  -H "Authorization: token ${GITHUB_PAT}" \
  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/registration-token \
  | jq -r .token)

echo "⚙️ Configuring the runner..."
./config.sh \
  --url "https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}" \
  --token "$REG_TOKEN" \
  --name "$RUNNER_NAME" \
  --work "$RUNNER_WORK_DIR" \
  --labels "$RUNNER_LABELS" \
  --unattended

echo "🚀 Starting the runner..."
./run.sh

