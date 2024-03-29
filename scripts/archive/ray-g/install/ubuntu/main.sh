#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "helper.sh" \
    && cd - &> /dev/null

# Register apt installer
regist_pkg_installer "apt" "install_package"

function pre_install() {
    update
}

function post_install() {
    :
}

function install_docker() {
    execute "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -" || return $?
    execute "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"" || return $?
    update || return $?
    execute "apt-cache policy docker-ce" || return $?
    install_package "docker-ce" "Docker CE" || return $?
    execute "sudo usermod -aG docker $(whoami)" || return $?
    # execute "sudo mkdir /docker" || return $?
    # execute "sudo ln -s /docker /var/lib/docker" || return $?
    # execute "echo 'DOCKER_OPTS=\"-g /docker\"' | sudo tee /etc/default/docker" || return $?

    # # Install Docker Compose
    # if ! cmd_exists "docker-compose"; then
    #     if cmd_exists "pip"; then
    #         execute "sudo pip install docker-compose" "Docker Compose"
    #     else
    #         print_error "Failed to install docker-compose. 'pip' is not installed properly"
    #         return 1
    #     fi
    # fi
}

# Install Node.JS
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
function install_nodejs10() {
    execute "curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -" || return $?
    install_package "nodejs" "NodeJS_10"
}

function install_nodejs12() {
    execute "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -" || return $?
    install_package "nodejs" "NodeJS_12"
}

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

function install_rust() {
    if ! cmd_exists "${pkg_exe}"; then
        execute "curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path"
        return $?
    fi
}

function install_vscode() {
    local vscode="vscode_stable_devstrap.deb"
    execute "wget --no-check-certificate https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O $vscode" || return $?
    execute "sudo dpkg -i $vscode"
    local exitCode=$?
    execute "rm $vscode"
    return $exitCode
}

function install_emacs_ppa() {
    execute "sudo add-apt-repository ppa:kelleyk/emacs -y && sudo apt-get update"
    install_package
}

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
    fi
}

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

function install_bazel() {
    execute "sudo apt-get install openjdk-8-jdk" || return $?
    execute "echo \"deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8\" | sudo tee /etc/apt/sources.list.d/bazel.list" || return $?
    execute "curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -" || return $?
    update || return $?
    install_package
}

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
