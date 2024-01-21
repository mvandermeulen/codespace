#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
LOCAL_BIN=${LOCAL_BIN:-"$HOME/.local/bin"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

bash -c 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"' \
    && chmod +x $HOME/kubectl && mv $HOME/kubectl "${LOCAL_BIN}/kubectl"

exit 0