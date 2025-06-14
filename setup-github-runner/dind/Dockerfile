FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    curl jq sudo libssl-dev ca-certificates
RUN useradd -m docker && mkdir /home/docker/actions-runner
WORKDIR /home/docker/actions-runner

# Download runner
ARG RUNNER_VERSION=2.325.0
RUN curl -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  | tar xz && ./bin/installdependencies.sh

COPY start.sh .
RUN chmod +x start.sh
USER docker
ENTRYPOINT ["./start.sh"]

