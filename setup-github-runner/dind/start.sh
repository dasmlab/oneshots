#!/bin/bash
REG_TOKEN=$(curl -sX POST -H "Authorization: token ${GH_TOKEN}" \
  https://api.github.com/repos/${GH_OWNER}/${GH_REPO}/actions/runners/registration-token \
  | jq -r .token)
./config.sh --unattended --url https://github.com/${GH_OWNER}/${GH_REPO} --token "${REG_TOKEN}"
trap 'cleanup; exit 130' INT TERM
cleanup() { ./config.sh remove --unattended --token "${REG_TOKEN}"; }
while true; do ./run.sh; sleep 5; done

