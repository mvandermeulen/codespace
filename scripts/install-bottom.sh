#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

BOTTOM_VERSION="0.9.6"
BOTTOM_INSTALLER_NAME="bottom_0.9.6_amd64.deb"

curl -Lo "${INSTALL_PATH}/${BOTTOM_INSTALLER_NAME}" "https://github.com/ClementTsang/bottom/releases/download/${BOTTOM_VERSION}/${BOTTOM_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${BOTTOM_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${BOTTOM_INSTALLER_NAME}"

exit 0