FROM circleci/runner-agent:machine-3
RUN sudo apt-get update; \
    sudo apt-get install --no-install-recommends -y \
     docker

# Add Docker's official GPG key:
RUN sudo apt-get update -y
RUN sudo apt-get install ca-certificates curl -y
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update

# Install Latest Docker 
RUN sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Set the circleci container user to the group
RUN sudo groupdd -g 999 docker && sudo usermod -aG docker circleci

