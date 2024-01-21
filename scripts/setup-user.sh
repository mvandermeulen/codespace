#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

export TZ=${TZ:-"Australia/Sydney"}

#
# Add work user
groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME


# Configure home, user, and working dir
export OS_NAME=ubuntu
export USER=ubuntu
useradd -m -s /bin/zsh $USER
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
export HOME=/home/$USER
export CODESPACE=codespace
export RUSER=root
export RHOME=/root

# Create codespace directory
mkdir -p $HOME/$CODESPACE

# Clone dotfiles from public repo
git clone https://github.com/tw-studio/dotfiles $HOME/.dotfiles
