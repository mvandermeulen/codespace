#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
CODESPACE=${CODESPACE:-"codespace"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}
ASDF_VERSION=${ASDF_VERSION:-"v0.14.0"}

git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch "$ASDF_VERSION"
source $HOME/.asdf/asdf.sh

exit 0