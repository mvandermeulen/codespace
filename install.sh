#!/bin/sh
IMAGE_USER="mvandermeulen"
IMAGE_NAME="codespace"
IMAGE_TAG="latest"

CRUN="$(command -v docker)"
if [[ -z "$CRUN" ]]; then
    CRUN="$(command -v podman)"
fi

if [[ -f "$HOME/.gitconfig" ]]; then
    $CRUN run -it -v $(pwd):/home/workspace --detach-keys="ctrl-d" -v ~/.gitconfig:/etc/gitconfig "${IMAGE_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
else
    $CRUN run -it -v $(pwd):/home/workspace --detach-keys="ctrl-d" "${IMAGE_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
fi

