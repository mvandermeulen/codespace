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



function install_protobuf() {
    # http://google.github.io/proto-lens/installing-protoc.html
    local PB_VER=${DEVSTRAP_PROTOBUF_VER}
    local PB_ZIP="protoc-${PB_VER}-linux-x86_64.zip"
    local PROTOC_INC_PATH="/usr/local/include/google"
    local PROTOC_EXE_PATH="/usr/local/bin/protoc"

    if ! cmd_exists "${pkg_exe}"; then
        execute "curl -OL https://github.com/google/protobuf/releases/download/v${PB_VER}/${PB_ZIP}"
        execute "sudo unzip -o ${PB_ZIP} -d /usr/local bin/protoc && sudo unzip -o ${PB_ZIP} -d /usr/local include/*"
        execute "sudo chmod o+rx ${PROTOC_EXE_PATH}"
        execute "sudo chmod o+rx -R ${PROTOC_INC_PATH}"
        local exitCode=$?
        execute "rm -f ${PB_ZIP}"

        return $exitCode
    else
        return 0
    fi
}

function remove_protobuf() {
    local PROTOC_EXE_PATH="/usr/local/bin/protoc"
    local PROTOC_INC_PATH="/usr/local/include/google"
    local PROTOC_EXE="protoc"
    if cmd_exists "${PROTOC_EXE}"; then
        if [ -f "${PROTOC_EXE_PATH}" ]; then
            execute "sudo rm -f ${PROTOC_EXE_PATH}"
        fi
        if [ -d "${PROTOC_INC_PATH}" ]; then
            execute "sudo rm -rf ${PROTOC_INC_PATH}"
        fi
    fi
}

function upgrade_protobuf() {
    remove_protobuf
    install_protobuf
}






exit 0