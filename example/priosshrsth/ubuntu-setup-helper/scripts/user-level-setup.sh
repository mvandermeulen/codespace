#!/bin/env bash

temp=$( realpath "$0"  )
CURRENT_DIR=$(dirname "$temp")

## Set zsh as default shell
echo "Setting up zsh"

## Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
source ~/.zshrc
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

if [[ -r "${XDG_CACHE_HOME:-$HOME/.ssh}/" ]]; then
  chmod -R 700 ~/.ssh/
fi

## source ~/.zshrc

## Setup ruby
${CURRENT_DIR}/ruby-setup.sh

## Setup nvm
${CURRENT_DIR}/nvm-setup.sh

cp ./../configs/. ~/

source ~/.zshrc

${CURRENT_DIR}/docker-setup.sh

sudo tee -a ~/.profile > /dev/null <<EOT
xset led on
sudo iptables -t nat -A OUTPUT -o lo -d 127.0.0.2 -p tcp --dport 80 -j DNAT  --to-destination 127.0.0.1:81
sudo iptables -t nat -A OUTPUT -o lo -d 127.0.0.2 -p tcp --dport 443 -j DNAT  --to-destination 127.0.0.1:444

EOT