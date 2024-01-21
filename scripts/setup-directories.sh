#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
CODESPACE=${CODESPACE:-"codespace"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

mkdir -pv $INSTALL_PATH && mkdir -pv $HOME/$CODESPACE \
    && mkdir -pv $HOME/.local/{src,bin,share,docs,include,tmp,log,lib,cache,history} \
    && mkdir -pv $HOME/.config/nvim \
    && mkdir -pv $HOME/.tmux/{scripts,themes,plugins} \
    && mkdir -pv $HOME/.tmuxp

exit 0