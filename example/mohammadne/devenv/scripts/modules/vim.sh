#!/bin/bash

info() {
	echo -n "install VIM and relevant plugins"
}

run() {
    sudo dnf install -qy vim

    linker $1 "$dotfiles_directory/vim/vimrc" "$HOME/.vimrc"

    curl_if_not_exists "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$HOME/.vim/autoload/plug.vim" -fL --create-dirs
    vim -E +'PlugInstall --sync' +qall > /dev/null || print_error $1 "Something went wrong installing vim plugins."
}
