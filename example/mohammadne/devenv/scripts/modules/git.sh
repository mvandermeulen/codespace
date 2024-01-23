#!/bin/bash

info() {
	echo -n "install git"
}

run() {
    sudo dnf install -qy git

    linker $1 "$dotfiles_directory/git" "$HOME/.config/git"
}
