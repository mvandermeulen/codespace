#!/bin/bash

info() {
	echo -n "install ZSH and relevant plugins (ohmyzsh)"
}

run() {
    sudo dnf install -qy zsh

    export ZDOTDIR="$HOME/.config/zsh"
    add_zdotdir $ZDOTDIR # add zdotdir value to the global zshenv file

    linker $1 "$dotfiles_directory/zsh" "$ZDOTDIR"

    # install ohmyzsh manually without using ohmyzsh installer
    # ohmyzsh installer: https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    ohmyzsh_directory="$ZDOTDIR/ohmyzsh"
    clone_if_not_exists "https://github.com/ohmyzsh/ohmyzsh.git" "$ohmyzsh_directory" --depth 1 -b master

    # installing custom ohmyzsh plugins (default are present in ohmyzsh directory)
    local ohmyzsh_custom="$ohmyzsh_directory/custom"
    clone_if_not_exists https://github.com/romkatv/powerlevel10k.git $ohmyzsh_custom/themes/powerlevel10k --depth=1
    clone_if_not_exists https://github.com/zsh-users/zsh-autosuggestions "$ohmyzsh_custom/plugins/zsh-autosuggestions"
    clone_if_not_exists https://github.com/zsh-users/zsh-syntax-highlighting.git "$ohmyzsh_custom/plugins/zsh-syntax-highlighting"
    clone_if_not_exists https://github.com/zsh-users/zsh-history-substring-search "$ohmyzsh_custom/plugins/zsh-history-substring-search"
    clone_if_not_exists https://github.com/zsh-users/zsh-completions "$ohmyzsh_custom/plugins/zsh-completions"

    # change default shell to zsh
    sudo usermod --shell "$(which zsh)" "$(whoami)"
}

function add_zdotdir() {
    value="$1"

    file="/etc/zshenv"
    key="export ZDOTDIR"

    # Check if the key exists in the last line
    if grep -q "^$key=" "$file"; then
        # If the key exists, update its value using sed
        sudo sed -i "s#$key=.*#$key=$value#" "$file"
    else
        # If the key does not exist, add it to the last line
        echo -e "\n$key=$value" | sudo tee -a "$file" > /dev/null
    fi
}
