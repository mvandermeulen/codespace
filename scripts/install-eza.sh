#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

DOWNLOAD_BASE_URL="https://github.com/eza-community/eza/releases/download"
EZA_VERSION="v0.17.2"
EZA_INSTALLER_ARCHIVE="eza_x86_64-unknown-linux-musl.tar.gz"

curl -Lo "${INSTALL_PATH}/${EZA_INSTALLER_ARCHIVE}" "${DOWNLOAD_BASE_URL}/${EZA_VERSION}/${EZA_INSTALLER_ARCHIVE}"
tar -xzf "${INSTALL_PATH}/${EZA_INSTALLER_ARCHIVE}" -C "$HOME/.local/bin" && rm -f "${INSTALL_PATH}/${EZA_INSTALLER_ARCHIVE}"

exit 0