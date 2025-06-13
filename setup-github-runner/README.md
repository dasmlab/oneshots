# OneShot GitHub Runner (Containerized)

This repo lets you spin up a **GitHub Actions Runner in a container** using GitHub’s one-time registration token.

##  Prerequisites

- Docker installed
- GitHub repo with self-hosted runner enabled
- GitHub-generated one-time **runner token**

##  Usage

1. Go to:
https://github.com/<org>/<repo>/settings/actions/runners/new

- Choose Linux + x64
- Copy the **registration token** and repo URL

2. Run the script:

```bash
./run-runner.sh https://github.com/YOURORG/YOURREPO YOUR_TOKEN_HERE
