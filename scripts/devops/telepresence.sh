#!/bin/bash

info() {
	echo -n "install telepresence client"
}

run() {
    local binary_path="/usr/local/bin/telepresence"
    local version="v2.17.0"
    local url="https://github.com/telepresenceio/telepresence/releases/download/$version/telepresence-linux-amd64"    

    if check_versioned_binary $1 $binary_path $version "version"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    chmod +x "$result" && sudo mv $result $binary_path
}
