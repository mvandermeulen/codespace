#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}
CODESPACE=${CODESPACE:-"codespace"}
## APP VARS
APP_VERSION=${APP_VERSION:-"v0.14.0"}
APP_INSTALLER_SRC_FILENAME=${APP_INSTALLER_SRC_FILENAME:-"install.deb"}
APP_INSTALLER_DST_FILENAME=${APP_INSTALLER_DST_FILENAME:-"$APP_INSTALLER_SRC_FILENAME"}
APP_DST_PATH=${APP_DST_PATH:-"$HOME/.local/bin"}
# URL
DOWNLOAD_BASE_URL=${DOWNLOAD_BASE_URL:-""}

# Get File
curl -Lo "${INSTALL_PATH}/${APP_INSTALLER_DST_FILENAME}" "${DOWNLOAD_BASE_URL}/${APP_VERSION}/${APP_INSTALLER_SRC_FILENAME}"

# .deb files
sudo dpkg -i "${INSTALL_PATH}/${APP_INSTALLER_DST_FILENAME}" && sudo rm -f "${INSTALL_PATH}/${APP_INSTALLER_DST_FILENAME}"

# Archive Files
tar -xzf "${INSTALL_PATH}/${APP_INSTALLER_DST_FILENAME}" -C "${APP_DST_PATH}" && rm -f "${INSTALL_PATH}/${APP_INSTALLER_DST_FILENAME}"
chmod +x "${APP_DST_PATH}/"


function upgrade_peco() {
    remove_peco
    install_peco
}

function remove_peco() {
    local PECO_ROOT="/usr/local/peco"
    local PECO_EXE="peco"
    local PECO_LINK="/usr/local/bin/peco"
    if cmd_exists "${PECO_EXE}"; then
        if [[ -d "${PECO_ROOT}" && "${RG_LINK}" == "$(which peco)" && "$(realpath ${PECO_LINK})" == "${PECO_ROOT}/peco" ]]; then
            execute "sudo rm -rf ${PECO_ROOT}"
            execute "sudo rm ${PECO_LINK}"
        fi
    fi
}

function install_peco() {
    local PECO_VER=${DEVSTRAP_PECO_VER}
    local PECO_TAR="peco_linux_amd64.tar.gz"

    if ! cmd_exists "${pkg_exe}"; then
        execute "wget --no-check-certificate https://github.com/peco/peco/releases/download/v${PECO_VER}/${PECO_TAR}" || return $?
        execute "sudo mkdir -p /usr/local/peco && sudo tar -C /usr/local/peco --strip-components 1 -xzf ${PECO_TAR}"
        if [ ! -e "/usr/local/bin/peco" ]; then
            execute "sudo ln -s /usr/local/peco/peco /usr/local/bin/peco"
        fi
        local exitCode=$?
        execute "rm ${PECO_TAR}"

        return $exitCode
    else
        return 0
    fi
}



exit 0