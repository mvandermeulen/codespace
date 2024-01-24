#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
LOCAL_BIN=${LOCAL_BIN:-"$HOME/.local/bin"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

wget -O $INSTALL_PATH/natscli-0.0.28-amd64.deb https://github.com/nats-io/natscli/releases/download/v0.0.28/nats-0.0.28-amd64.deb \
    && sudo dpkg -i $INSTALL_PATH/natscli-0.0.28-amd64.deb

exit 0