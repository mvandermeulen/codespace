#!/bin/bash

# parameter 1: url - string
# parameter 2: destination directory/file - string
# parameter 3: clone options
function curl_if_not_exists() {
    if [ -d "$2" ] || [ -f "$2" ] ; then
        return
    fi

    curl "$1" -o "$2" "${@:3}" # --silent
}

# parameter 1: module - string
# parameter 2: binary path - string
# parameter 3: version - string
# parameter 4: version check command - string
function check_versioned_binary() {
	if [ -f "$2" ] && echo $($2 $4) | grep -q $3; then
        print_success $1 "module with version $3 is already installed"
        return 0 # true
	fi

    return 1 # false
}

# parameter 1: module - string
# parameter 2: url - string
function download_file() {
    local random_tail=$(tr -dc 'a-z0-9' </dev/urandom | head -c 10)
    local download_path="/tmp/${random_tail}"

    if ! curl "$url" -o "$download_path" -SL; then
        print_error $1 "download has been failed ($url)"
        return 1
    fi
    
    echo $download_path
}
