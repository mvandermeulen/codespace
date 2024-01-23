#!/bin/bash

info() {
	echo -n "install aria2 download manager"
}

run() {
    sudo apt install -qy aria2

    linker $1 "$dotfiles_directory/aria2" "$HOME/.aria2"
}
