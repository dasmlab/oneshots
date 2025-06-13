FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    curl \
    jq \
    tar \
    sudo \
    libicu-dev \
    libssl-dev \
    libkrb5-3 \
    zlib1g \
    libcurl4 \
    libgssapi-krb5-2 \
    ca-certificates && \
    useradd -m runner && \
    mkdir -p /runner && \
    chown runner:runner /runner

WORKDIR /runner
USER runner

ENV RUNNER_VERSION=2.325.0

RUN curl -L -o actions-runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

