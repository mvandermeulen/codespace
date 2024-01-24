#!/usr/bin/env bash

set -eu -o pipefail

# Required parameters
repo_remote="${1}"
path_dir_container_script="${2}"

# This variable is used for identifying docker image, volumes, git branches,etc.
readonly ID=ifc

volume_name="ifraixedes-ubuntu-${ID}"
if ! docker volume ls | grep ${volume_name} >/dev/null; then
	docker volume create ${volume_name}
fi

map_dev_arduino=""
if [[ -c /dev/ttyACM0 ]]; then
	uucp_gid=$(grep uucp /etc/group | cut -d ':' -f 3)
	map_dev_arduino="--device=/dev/ttyACM0 \
	--group-add ${uucp_gid} "
fi

user_name=$(id -un)
repo_branch="${ID}"
persistent_dir="/home/${user_name}/persistent"

# group isn't passed to --user flag because it allows to use all the groups that
# the host machine user belongs. This is useful to be able to use docker-cli
# installed in the container connecting to the host docker daemon.
# So do `--user "${user_name}"` instead of `--user "${user_name}:${user_name}"`.
docker run --name ifraixedes-${ID} \
	--rm \
	-ti \
	--user "${user_name}" \
	--hostname if${ID} \
	--add-host=if${ID}:127.0.0.1 \
	--network=host \
	${map_dev_arduino} \
	--mount "type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock" \
	--mount "type=volume,src=${volume_name},dst=/home/${user_name}/persistent" \
	--mount "type=bind,src=${HOME},dst=/hostmachine" \
	--mount "type=bind,src=${HOME}/.Xauthority,dst=/home/${user_name}/.Xauthority" \
	--env DISPLAY="${DISPLAY}" \
	ifraixedes/ubuntu/${ID}:22.04 \
	zsh -c \
	"${path_dir_container_script}/init-${ID}.sh ${persistent_dir} ${repo_remote} ${repo_branch} && \
    ${path_dir_container_script}/entrypoint-${ID}.sh"

# The bind to .Xautority and the DISPLAY environment variable mapping are for
# making possible to run GUI apps through the host machine X server.
# The host machine can authorize the docker containers to connect to the X
# server executing `xhost +"local:"` if it isn't already authorized. To list the
# authorizations just execute `xhost`.
