#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

NNN_VERSION="v4.9"
NNN_INSTALLER_NAME="nnn-musl-static-4.9.x86_64.tar.gz"

curl -Lo "${INSTALL_PATH}/${NNN_INSTALLER_NAME}" "https://github.com/jarun/nnn/releases/download/${NNN_VERSION}/${NNN_INSTALLER_NAME}"
tar -xzf "${INSTALL_PATH}/${NNN_INSTALLER_NAME}" -C "$HOME/.local/bin"

exit 0