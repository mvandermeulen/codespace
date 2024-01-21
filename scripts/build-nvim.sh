#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}


sudo apt-get update

apt-install software-properties-common

# Fix the permissions from the copy...
sudo chown -R "$USER:$USER" "$HOME/.config/nvim"

sudo chown "$USER:$USER" "$HOME/.editorconfig"

sudo apt-get update

# Install neovim
curl -Lo /tmp/nvim.deb https://github.com/neovim/neovim/releases/download/v0.8.1/nvim-linux64.deb
sudo dpkg -i /tmp/nvim.deb
rm -rf /tmp/nvim.deb


# needed by various plugins
sudo pip3 install pynvim

# Add environment variables and `vim` alias.
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"

sudo rm /tmp/bashrc-additions.sh

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install all plugins.
nvim +PlugInstall +qall

# Shellcheck: shell script linter
apt-install shellcheck

# Install ctags for code jump
apt-install exuberant-ctags

# Install editorconfig cli needed for vim plugin
apt-install editorconfig

# Cleanups
sudo apt-get purge software-properties-common -y
sudo apt-get autoremove -y
sudo apt-get clean
rm -rf /tmp/shellcheck
rm -rf ~/.cabal
sudo rm -rf /var/lib/apt/lists/*