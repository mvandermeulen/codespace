#!/bin/bash

info() {
	echo -n "install helmsman to manage your deployment"
}

run() {
    local binary_path="/usr/local/bin/helmsman"
    local version="3.17.0"
    local url="https://github.com/Praqma/helmsman/releases/download/v${version}/helmsman_${version}_linux_amd64.tar.gz"

    if check_versioned_binary $1 $binary_path $version "-v"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    sudo tar -C $(dirname $binary_path) -xzf $result "helmsman" && rm -rf "$result"
}
