#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

DOWNLOAD_BASE_URL="https://github.com/sharkdp/bat/releases/download"
BAT_VERSION="v0.24.0"
BAT_INSTALLER_NAME="bat-musl_0.24.0_amd64.deb"

curl -Lo "${INSTALL_PATH}/${BAT_INSTALLER_NAME}" "${DOWNLOAD_BASE_URL}/${BAT_VERSION}/${BAT_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${BAT_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${BAT_INSTALLER_NAME}"

exit 0