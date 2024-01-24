#!/bin/bash

# parameter 1: url - string
# parameter 2: destination directory - string
# parameter 3: clone options
function clone_if_not_exists() {
    if [ -d "$2" ] ; then
        return
    fi

    git clone "$1" "$2" "${@:3}" -q
}

# parameter 1: module - string
# parameter 2: directory to be cloned - string
# parameter 3: remote https url - string
# parameter 4: remote ssh url - string
function full_clone() {
    local module=$1
    local directory=$2
    local remote_https=$3
    local remote_ssh=$4

    # clone if not exist
    if [ ! -d "$directory" ]; then
        mkdir -p "$(dirname $directory)"
        git clone $remote_https $directory -q
        cd $directory && git remote set-url origin $remote_ssh
        return
    fi

    if [ ! -d "$directory/.git" ]; then
        print_error $module "directory is present but is not a git repository"
        exit 1
    fi

    current_remote="$(cd $directory && git config --get remote.origin.url)"
    if [ "$current_remote" != "$remote_ssh" ] && [ "$current_remote" != "$remote_https" ]; then
        print_error $module "existing directory has an invalid remote url"
        exit 1
    fi

    cd $directory && git remote set-url origin $remote_ssh
    cd $directory && git pull origin -q --force
    if [ $? -ne 0 ]; then
        print_error $module "unable to pull the latest changes"
        exit 1
    fi
}
