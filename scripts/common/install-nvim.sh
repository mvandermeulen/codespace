#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
CODESPACE=${CODESPACE:-"codespace"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}
TARGET=${TARGET:-"stable"}
# Often /usr/local/
NVIM_INSTALL_PREFIX=${NVIM_INSTALL_PREFIX:-"/home/$USERNAME/.local"}
NEOVIM_INSTALL_VERSION=${NEOVIM_INSTALL_VERSION:-"v0.9.5"}
NEOVIM_INSTALL_SRC_FILENAME="nvim-linux64.tar.gz"
# NEOVIM_SRC_FILENAME="nvim.appimage"
NEOVIM_INSTALL_DST_FILENAME="${NEOVIM_INSTALL_SRC_FILENAME}"
NEOVIM_INSTALL_BASE_URL="https://github.com/neovim/neovim/releases/download"

NEOVIM_CONFIG_SOURCE_DIR="$HOME/config/nvim"

# Install neovim
curl -Lo "${INSTALL_PATH}/${NEOVIM_INSTALL_DST_FILENAME}" "${NEOVIM_INSTALL_BASE_URL}/${NEOVIM_INSTALL_VERSION}/${NEOVIM_INSTALL_SRC_FILENAME}"
sudo tar xzvf "${INSTALL_PATH}/${NEOVIM_INSTALL_DST_FILENAME}" -C /usr/bin/
sudo ln -s /usr/bin/nvim-linux64/bin/nvim /usr/bin/nvim
rm "${INSTALL_PATH}/${NEOVIM_INSTALL_DST_FILENAME}"

# Build neovim
#

# Should use CMAKE_BUILD_TYPE=Release -j 4
# git clone https://github.com/neovim/neovim.git "$INSTALL_PATH/neovim" && \
#     cd $INSTALL_PATH/neovim && git fetch --all --tags -f && git checkout ${TARGET} && \
#     make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="${NVIM_INSTALL_PREFIX}/" && \
#     make install && \
#     strip "${NVIM_INSTALL_PREFIX}/bin/nvim"



# Alias vim to nvim



# needed by various plugins
# sudo pip3 install pynvim

# Add environment variables and `vim` alias.
# cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"

# sudo rm /tmp/bashrc-additions.sh

# Install Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# Create directories
mkdir -p $HOME/.config/nvim/colors && mkdir -p $HOME/.local/share/nvim/site/autoload

# Copy configuration.
cp -Rv $NEOVIM_CONFIG_SOURCE_DIR/* $HOME/.config/nvim/

# Run neovim and install plugins
# nvim --headless +PlugInstall +qall
# nvim --headless +"Lazy! sync" +q
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Cleanups
sudo apt-get purge software-properties-common -y && sudo apt-get autoremove -y && sudo apt-get clean

exit 0