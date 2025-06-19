#!/bin/bash
#
# Fetchs the linux x86_64 binary from Source and installs it
#
wget https://github.com/CircleCI-Public/circleci-cli/releases/download/v0.1.32367/circleci-cli_0.1.32367_linux_amd64.tar.gz  
tar xvf circleci-cli_0.1.32367_linux_amd64.tar.gz
sudo mv circleci-cli_0.1.32367_linux_amd64/circleci /usr/local/bin/.





