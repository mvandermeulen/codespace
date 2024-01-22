#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

FD_VERSION="v9.0.0"
FD_INSTALLER_NAME="fd-musl_9.0.0_amd64.deb"

curl -Lo "${INSTALL_PATH}/${FD_INSTALLER_NAME}" "https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/${FD_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${FD_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${FD_INSTALLER_NAME}"

exit 0