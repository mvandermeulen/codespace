#!/bin/sh
WORKSPACE_DIR_NAME=${1-.workspace}
WORKSPACE_VOLUME_SRC="$(pwd)/${WORKSPACE_DIR_NAME}"

IMAGE_USER="mvandermeulen"
IMAGE_NAME="codespace"
IMAGE_TAG="latest"

CRUN="$(command -v docker)"
if [[ -z "$CRUN" ]]; then
    CRUN="$(command -v podman)"
fi

if [[ ! -e "$WORKSPACE_VOLUME_SRC" ]]; then
    if [[ -d "${HOME}/${WORKSPACE_DIR_NAME}" ]]; then
        WORKSPACE_VOLUME_SRC="${HOME}/${WORKSPACE_DIR_NAME}"
    else
        mkdir -p "${WORKSPACE_VOLUME_SRC}"
    fi
fi

if [[ -f "$HOME/.gitconfig" ]]; then
    $CRUN run -it -v $(pwd):/home/workspace --detach-keys="ctrl-d" -v ~/.gitconfig:/etc/gitconfig "${IMAGE_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
else
    $CRUN run -it -v $(pwd):/home/workspace --detach-keys="ctrl-d" "${IMAGE_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
fi
