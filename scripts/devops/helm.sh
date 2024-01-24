#!/bin/bash

info() {
    echo -n "install helm as a k8s package manager solution"
}

run() {
    local binary_path="/usr/local/bin/helm"
    local version=$(curl -L --silent --show-error --fail "https://get.helm.sh/helm-latest-version")
    local url="https://get.helm.sh/helm-${version}-linux-amd64.tar.gz"
    
    if check_versioned_binary $1 $binary_path $version "version"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    sudo tar -C $(dirname $binary_path) -xzf $result --strip-components=1 "linux-amd64/helm" && rm -rf "$result"
    
    # install required helm plugins
    $binary_path plugin install https://github.com/databus23/helm-diff --version v3.8.1
    $binary_path plugin install https://github.com/jkroepke/helm-secrets --version v4.5.1
}
