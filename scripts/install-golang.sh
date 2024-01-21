#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}
GOLANG_VERSION=${GOLANG_VERSION:-"1.21.5"}
GOLANG_DIR=${GOLANG_DIR:-"/usr/go"}


wget -O "$INSTALL_PATH/go${GOLANG_VERSION}.linux-amd64.tar.gz" "https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" \
    && sudo mkdir -p "${GOLANG_DIR}" \
    && sudo tar -C "${GOLANG_DIR}" -xvf "$INSTALL_PATH/go${GOLANG_VERSION}.linux-amd64.tar.gz" \
    && sudo update-alternatives --install /usr/bin/go go "${GOLANG_DIR}/go/bin/go" 100 --force \
    && sudo update-alternatives --install /usr/bin/gofmt gofmt "${GOLANG_DIR}/go/bin/gofmt" 100 --force

exit 0