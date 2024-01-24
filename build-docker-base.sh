#!/usr/bin/env bash

set -eu -o pipefail

# configuration parameters
user_name=$(id -un)
user_id=$(id -u)
user_pwd=

# User's password to use
if [[ "$#" -ge 1 ]]; then
	user_pwd="${1}"
else
	read -r -s -p "specify password for ${user_name}  user: " user_pwd
fi

docker build \
	--force-rm \
	--no-cache \
	--pull \
	--build-arg USER_NAME="${user_name}" \
	--build-arg USER_ID="${user_id}" \
	--build-arg USER_PWD="${user_pwd}" \
	-f Dockerfile.base \
	-t ifraixedes/ubuntu/base:22.04 .
