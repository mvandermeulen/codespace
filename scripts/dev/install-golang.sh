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
    && sudo update-alternatives --install /usr/bin/gofmt gofmt "${GOLANG_DIR}/go/bin/gofmt" 100 --force \
    && sudo ln "${GOLANG_DIR}/go/bin/go" /usr/local/bin/go

function upgrade_golang() {
    remove_golang
    install_golang
}

function remove_golang() {
    local GO_ROOT="/usr/local/go"
    local GO_EXE="go"
    if cmd_exists "${GO_EXE}"; then
        if [[ -d "${GO_ROOT}" && "${GO_ROOT}/bin/go" == "$(which go)" ]]; then
            execute "sudo rm -rf ${GO_ROOT}"
        fi
    fi
}

function install_golang() {
    local GO_VER=$DEVSTRAP_GO_VER
    local GO_OS="linux"
    local GO_ARCH="amd64"

    if ! cmd_exists "${pkg_exe}"; then
        execute "wget --no-check-certificate https://go.dev/dl/go${GO_VER}.${GO_OS}-${GO_ARCH}.tar.gz" || return $?
        execute "sudo tar -C /usr/local -xzf go${GO_VER}.${GO_OS}-${GO_ARCH}.tar.gz"
        local exitCode=$?
        execute "rm go${GO_VER}.${GO_OS}-${GO_ARCH}.tar.gz"

        if [ $exitCode -eq 0 ]; then
            # Successfully installed Golang, setup environment
            export GOPATH="${HOME}/.go"
            export PATH=${GOPATH}/bin:/usr/local/go/bin:$PATH
        fi
        return $exitCode
    else
        return 0
    fi
}

exit 0