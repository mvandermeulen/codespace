#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}


git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
eval "$(~/.rbenv/bin/rbenv init - zsh)"
rbenv install -l
gem install neovim

exit 0