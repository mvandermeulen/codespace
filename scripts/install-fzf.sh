#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
RHOME=${RHOME:-"/root"}

# Install fzf from git
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf \
    && cp -r $HOME/.fzf $RHOME/.fzf \
    && $HOME/.fzf/install --all || true \
    && rm -f $HOME/.bashrc $HOME/.fzf/code.bash

exit 0