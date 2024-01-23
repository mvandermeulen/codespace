#!/usr/bin/env bash

# This scripts install the Docker cli...

set -eux -o pipefail

# Use the same group ID that the docker group of the host machine for adding
# the user to such group
user_name=${1}
docker_gid=${2}

groupadd -g "${docker_gid}" docker
usermod -a -G docker "${user_name}"

# Install required dependency packages.
# some of this dependencies allow apt to use a repository over HTTPS.
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key.
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install the Docker client.
apt-get update
apt-get install -y docker-ce-cli docker-compose-plugin
