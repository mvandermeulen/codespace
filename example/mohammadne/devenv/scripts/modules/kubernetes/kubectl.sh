#!/bin/bash

info() {
    echo -n "install kubectl client binary"
}

run() {
    local binary_path="/usr/local/bin/kubectl"
    local version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    local url="https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl"
    
    if check_versioned_binary $1 $binary_path $version "version --client"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    chmod +x "$result" && sudo mv $result $binary_path
    
    _install_kubectl_ns_plugin
    _install_kubectl_neat_plugin
}

_install_kubectl_ns_plugin() {
    sudo dnf install fzf -yq
    
    local binary_path="/usr/local/bin/kubectl-ns"
    local url="https://raw.githubusercontent.com/weibeld/kubectl-ns/master/kubectl-ns"
    
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    chmod +x "$result" && sudo rm -rf $binary_path && sudo mv $result $binary_path
}

_install_kubectl_neat_plugin() {
    local binary_path="/usr/local/bin/kubectl-neat"
    local version="v2.0.3"
    local url="https://github.com/itaysk/kubectl-neat/releases/download/$version/kubectl-neat_linux_amd64.tar.gz"
    
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    chmod +x "$result" && sudo rm -rf $binary_path && sudo mv $result $binary_path
}
