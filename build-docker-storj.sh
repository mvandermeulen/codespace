#!/usr/bin/env bash

set -eu -o pipefail

# configuration parameters
user_name=$(id -un)
docker_gid=$(grep docker /etc/group | cut -d ':' -f 3)

docker build \
  --force-rm \
  --no-cache \
  --build-arg USER_NAME="${user_name}" \
  --build-arg DOCKER_GID="${docker_gid}" \
  -f Dockerfile.storj \
  -t ifraixedes/ubuntu/storj:22.04 .
