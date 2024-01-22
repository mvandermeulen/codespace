#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

DOWNLOAD_BASE_URL="https://github.com/gopasspw/gopass/releases/download"
GOPASS_VERSION="v1.15.10"
GOPASS_INSTALLER_NAME="gopass_1.15.10_linux_amd64.deb"

curl -Lo "${INSTALL_PATH}/${GOPASS_INSTALLER_NAME}" "${DOWNLOAD_BASE_URL}/${GOPASS_VERSION}/${GOPASS_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${GOPASS_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${GOPASS_INSTALLER_NAME}"

exit 0