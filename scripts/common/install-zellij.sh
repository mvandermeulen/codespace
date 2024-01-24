#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

ZELLIJ_VERSION="v0.34.4"
ZELLIJ_DOWNLOAD_FILE="zellij-aarch64-unknown-linux-musl.tar.gz"
ZELLIJ_DEST_FILE="${ZELLIJ_DOWNLOAD_FILE}"
ZELLIJ_BIN_FILE="zellij"
ZELLIJ_BIN_FILE_DEST="$HOME/.local/bin"

wget -O "${INSTALL_PATH}/${ZELLIJ_DEST_FILE}" "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/${ZELLIJ_DOWNLOAD_FILE}"
tar -xvf "${INSTALL_PATH}/${ZELLIJ_DEST_FILE}" -C "$ZELLIJ_BIN_FILE_DEST/"
chmod +x "${ZELLIJ_BIN_FILE_DEST}/${ZELLIJ_BIN_FILE}"

exit 0