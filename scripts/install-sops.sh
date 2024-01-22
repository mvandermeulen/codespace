#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

DOWNLOAD_BASE_URL="https://github.com/mozilla/sops/releases/download"
SOPS_VERSION="v3.8.1"
SOPS_INSTALLER_NAME="sops_3.8.1_amd64.deb"

curl -Lo "${INSTALL_PATH}/${SOPS_INSTALLER_NAME}" "${DOWNLOAD_BASE_URL}/${SOPS_VERSION}/${SOPS_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${SOPS_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${SOPS_INSTALLER_NAME}"

exit 0