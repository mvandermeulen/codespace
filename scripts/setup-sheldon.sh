#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}
SHELDON_PLUGIN_FILE="$HOME/.config/sheldon/plugins.toml"
SHELDON_SOURCE_PLUGIN_FILE="$HOME/config/sheldon/plugins.toml"

mkdir -p $HOME/.config/sheldon && sheldon init --shell zsh
if [[ -f $SHELDON_SOURCE_PLUGIN_FILE ]]; then
    cat $SHELDON_SOURCE_PLUGIN_FILE >> $SHELDON_PLUGIN_FILE
fi

exit 0