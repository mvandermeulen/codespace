#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

FD_VERSION="v9.0.0"
FD_INSTALLER_NAME="fd-musl_9.0.0_amd64.deb"

curl -Lo "${INSTALL_PATH}/${FD_INSTALLER_NAME}" "https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/${FD_INSTALLER_NAME}"
sudo dpkg -i "${INSTALL_PATH}/${FD_INSTALLER_NAME}" && sudo rm -f "${INSTALL_PATH}/${FD_INSTALLER_NAME}"



function upgrade_fd() {
    always_install_fd
}

function install_fd() {
    if ! cmd_exists "${pkg_exe}"; then
        always_install_fd
    else
        return 0
    fi
}

function always_install_fd() {
    local FD_VER=${DEVSTRAP_FD_VER}
    local FD_DEB="fd_${FD_VER}_amd64.deb"

    # if ! cmd_exists "${pkg_exe}"; then
        execute "wget --no-check-certificate https://github.com/sharkdp/fd/releases/download/v${FD_VER}/${FD_DEB}" || return $?
        execute "sudo dpkg -i ${FD_DEB}"
        local exitCode=$?
        execute "rm ${FD_DEB}"

        return $exitCode
    #else
    #    return 0
    #fi
}



exit 0