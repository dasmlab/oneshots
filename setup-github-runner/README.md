# OneShot GitHub Runner

This project provides a **one-shot script** to stand up a GitHub Actions self-hosted runner in minutes.

## What It Does

This script:
- Downloads the latest GitHub runner binary
- Registers the runner with your repo
- Starts it immediately

Perfect for:
- Dynamic build runners
- Dev/test runners behind firewalls
- Private CI environments

## Prerequisites

1. Ubuntu-based Linux machine (tested on 20.04+)
2. Internet access to `github.com`
3. GitHub Personal Access Token (PAT) with `repo` or `admin:org` scope

## GitHub PAT

Your PAT should be scoped as follows:

| Context     | Scope Required         |
|-------------|------------------------|
| User repo   | `repo`                 |
| Org repo    | `admin:org`, `repo`    |

## Setup

Edit the `setup-github-runner.sh` script to define:

```bash
GITHUB_OWNER="your-org-or-user"
GITHUB_REPO="your-repo-name"
GITHUB_PAT="your-token-here"

