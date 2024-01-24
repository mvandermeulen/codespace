#!/usr/bin/env bash

set -eu -o pipefail

# Required parameters
repo_remote="${1}"
path_dir_container_script="${2}"

volume_name=ifraixedes-ubuntu-base
if ! docker volume ls | grep ${volume_name} >/dev/null; then
	docker volume create ${volume_name}
fi

user_name=$(id -un)
repo_branch=master
persistent_dir="/home/${user_name}/persistent"

docker run --name ifraixedes-base \
	--rm \
	-ti \
	--user "${user_name}:${user_name}" \
	--hostname ifbase \
	--network=host \
	--mount type=volume,src="${volume_name}",dst=/home/"${user_name}"/persistent \
	--mount type=bind,src="${HOME}",dst=/hostmachine \
	ifraixedes/ubuntu/base:22.04 \
	zsh -c \
	"${path_dir_container_script}/init-base.sh ${persistent_dir} ${repo_remote} ${repo_branch} && \
    ${path_dir_container_script}/entrypoint-base.sh"
