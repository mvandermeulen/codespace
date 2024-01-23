#!/bin/bash

info() {
	echo -n "install kind for having local k8s cluster"
}

run() {
    local binary_path="/usr/local/bin/kind"
    local version="v0.20.0"
    local url="https://github.com/kubernetes-sigs/kind/releases/download/$version/kind-linux-amd64"

    if check_versioned_binary $1 $binary_path $version "version"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    chmod +x "$result" && sudo mv $result $binary_path
}
