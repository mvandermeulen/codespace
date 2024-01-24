#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

GIT_DELTA_VERSION="0.16.5"
GIT_DELTA_INSTALLER_NAME="git-delta-musl_0.16.5_amd64.deb"

curl -Lo "${INSTALL_PATH}/${GIT_DELTA_INSTALLER_NAME}" "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/${GIT_DELTA_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${GIT_DELTA_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${GIT_DELTA_INSTALLER_NAME}"

exit 0