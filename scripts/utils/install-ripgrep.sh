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


function upgrade_ripgrep() {
    remove_ripgrep
    install_ripgrep
}

function remove_ripgrep() {
    local RG_ROOT="/usr/local/rg"
    local RG_EXE="rg"
    local RG_LINK="/usr/local/bin/rg"
    if cmd_exists "${RG_EXE}"; then
        if [[ -d "${RG_ROOT}" && "${RG_LINK}" == "$(which rg)" && "$(realpath ${RG_LINK})" == "${RG_ROOT}/rg" ]]; then
            execute "sudo rm -rf ${RG_ROOT}"
            execute "sudo rm ${RG_LINK}"
        fi
    fi
}

function install_ripgrep() {
    local RG_VER=${DEVSTRAP_RG_VER}
    local RG_TAR="ripgrep-${RG_VER}-x86_64-unknown-linux-musl.tar.gz"

    if ! cmd_exists "${pkg_exe}"; then
        execute "wget --no-check-certificate https://github.com/BurntSushi/ripgrep/releases/download/${RG_VER}/${RG_TAR}" || return $?
        execute "sudo mkdir -p /usr/local/rg && sudo tar -C /usr/local/rg --strip-components 1 -xzf ${RG_TAR}"
        if [ ! -e "/usr/local/bin/rg" ]; then
            execute "sudo ln -s /usr/local/rg/rg /usr/local/bin/rg"
        fi
        local exitCode=$?
        execute "rm ${RG_TAR}"

        return $exitCode
    else
        return 0
    


exit 0