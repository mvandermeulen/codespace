#!/bin/bash

function ensure_fedora() {
    if [ "$(uname)" != 'Linux' ]; then
        print_error $module "Non linux platform"
        exit 1
    fi
    
    if [ "$(cat /etc/os-release | grep -E ^ID= | cut -d = -f 2)" != "fedora" ]; then
        print_error $module "non fedora distribution"
        exit 1
    fi
}
