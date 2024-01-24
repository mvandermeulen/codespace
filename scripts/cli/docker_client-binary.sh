#!/bin/bash

info() {
	echo -n "install docker client binary"
}

run() {
    local binary_path="/usr/local/bin/docker"
    local version="24.0.4"
    local url="https://download.docker.com/linux/static/stable/x86_64/docker-$version.tgz"

    if check_versioned_binary $1 $binary_path $version "--version"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    sudo tar -C $(dirname $binary_path) -xzf $result --strip-components=1 "docker/docker" && rm -rf "$result"
}
