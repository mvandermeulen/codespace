#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

DOWNLOAD_BASE_URL="https://github.com/BurntSushi/ripgrep/releases/download"
RIPGREP_VERSION="13.0.0"
RIPGREP_INSTALLER_NAME="ripgrep_13.0.0_amd64.deb"

curl -Lo "${INSTALL_PATH}/${RIPGREP_INSTALLER_NAME}" "${DOWNLOAD_BASE_URL}/${RIPGREP_VERSION}/${RIPGREP_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${RIPGREP_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${RIPGREP_INSTALLER_NAME}"

exit 0