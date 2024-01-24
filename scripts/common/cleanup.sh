#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
RHOME=${RHOME:-"/root"}
RUSER=${RUSER:-"root"}

# Cleanup
sudo rm -rf $HOME/.dotfiles
sudo rm -rf $HOME/scripts

# Give user their stuff and set default shells
# Fix insecure completion-dependent directories permissions
sudo chown -R $USERNAME $HOME \
    && sudo chmod g-w,o-w $HOME/.oh-my-zsh \
    && sudo chmod g-w,o-w $RHOME/.oh-my-zsh
    && sudo usermod -s /bin/zsh $USERNAME \
    && sudo usermod -s /bin/zsh $RUSER \
    && source ~/.zshrc

# Start zsh in codespace
# mkdir -p $HOME/$CODESPACE
# cd $HOME/$CODESPACE
# su - $USER -c "zsh"

# Cleanup cache
sudo apt-get autoremove -y && sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*
exit 0