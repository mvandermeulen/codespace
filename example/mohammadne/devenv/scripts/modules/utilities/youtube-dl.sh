#!/bin/bash

info() {
    echo -n "install youtube downloader"
}

run() {
    local binary_path="/usr/local/bin/youtube-dl"
    local version="2021.12.17"
    local url="https://yt-dl.org/downloads/latest/youtube-dl"
    
    if check_versioned_binary $1 $binary_path $version "version"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    chmod +x "$result" && sudo mv $result $binary_path
}
