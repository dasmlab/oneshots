#!/bin/bash
# Run this to update/upgrade your existing deployment (like after you change the values.yaml with new params)
helm upgrade  container-agent container-agent/container-agent -n circleci -f values.yaml

