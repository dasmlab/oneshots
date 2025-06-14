FROM ubuntu:22.04

# Install system packages including Docker CLI dependencies
RUN apt-get update && apt-get install -y \
    curl jq tar sudo bash \
    libicu-dev libssl-dev libkrb5-3 zlib1g \
    libcurl4 libgssapi-krb5-2 ca-certificates \
    gnupg lsb-release software-properties-common \
    && curl -fsSL https://get.docker.com | sh \
    && useradd -m runner \
    && mkdir -p /runner \
    && chown runner:runner /runner

# Set environment variable for runner version
ENV RUNNER_VERSION=2.325.0

# Create docker group with host GID
# Ensure group for /var/run/docker.sock GID exists and add runner to it
RUN getent group 988 || groupadd -g 988 dockerhost && \
    usermod -aG 988 runner
RUN usermod -aG root runner

# Set up working directory and switch to runner user
WORKDIR /runner
USER runner

# Download GitHub Actions runner
RUN curl -L -o actions-runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

