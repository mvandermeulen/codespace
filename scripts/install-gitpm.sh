#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

install_gitpm() {
    mkdir /home/"$username"/.local
    mkdir /home/"$username"/.local/bin
    curl https://gist.githubusercontent.com/kensleDev/9c52976e734994eb64ff187b19bdcffa/raw/b2907b0b7db3139b89697b460e3aecc4ffcbc21d/gitpm -o /home/"$username"/.local/bin/gitpm 
    sudo chmod u+x /home/"$username"/.local/bin/gitpm
    export PATH="$HOME/.local/bin:$PATH"
}


exit 0