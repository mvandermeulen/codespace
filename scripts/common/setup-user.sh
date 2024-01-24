#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

TZ=${TZ:-"Australia/Sydney"}
USERNAME=${USERNAME:-"dev"}
USER_UID=${USER_UID:-"1000"}
USER_GID=${USER_GID:-"1000"}
HOME=${HOME:-"/home/$USERNAME"}

# Add work user
groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME


exit 0