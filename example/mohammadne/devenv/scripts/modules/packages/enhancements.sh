#!/bin/bash

info() {
    echo -n "install packages required for development"
}

run() {
    local packages=(
        gnome-tweaks
    )
    
    sudo dnf install -qy "${packages[@]}"
}
