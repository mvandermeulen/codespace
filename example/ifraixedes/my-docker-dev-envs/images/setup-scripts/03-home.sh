#!/usr/bin/env bash

set -eux -o pipefail

# Required arguments
user_name=${1}

# Change default shell user
usermod --shell /usr/bin/zsh ${user_name}

# Cleaning current home and copying my dot files from specified repo
rm -rf "/home/${user_name}"
mkdir -p "/home/${user_name}"
chown -R "${user_name}":"${user_name}" "/home/${user_name}"
chmod 700 -R "/home/${user_name}"

# Change directory the user home directory to create the files
cd "/home/${user_name}"

# Install Oh My ZSH plugins and any extra plugin
if [ ! -d .oh-my-zsh ]; then
	git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# Install tmux plugin manager
if [ ! -d .tmux-tpm ]; then
	git clone https://github.com/tmux-plugins/tpm .tmux-tpm
fi

# Create directory for mapping the docker volume to persist binaries, configurations, etc., between runs.
mkdir -p persistent

# Reset the permissions of the new directories and files created in the user
# home directory
chown -R "${user_name}":"${user_name}" .
