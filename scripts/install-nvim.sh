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

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

git clone https://github.com/neovim/neovim.git "$INSTALL_PATH/neovim" && \
    cd $INSTALL_PATH/neovim && git fetch --all --tags -f && git checkout ${TARGET} && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="${NVIM_INSTALL_PREFIX}/" && \
    make install && \
    strip "${NVIM_INSTALL_PREFIX}/bin/nvim"


# Create directories
mkdir -p $HOME/.config/nvim/colors \
 && mkdir -p $HOME/.local/share/nvim/site/autoload

# Copy configuration.
 && cp $HOME/.dotfiles/neovim/init-ec2.vim $HOME/.config/nvim/init.vim \
 && cp $HOME/.dotfiles/neovim/monokai-fusion.vim $HOME/.config/nvim/colors/ \
 && cp $HOME/.dotfiles/neovim/plug.vim $HOME/.local/share/nvim/site/autoload/ \
 && cp $HOME/.dotfiles/neovim/dracula-airline.vim $HOME/.config/nvim/dracula.vim \
 && cp $HOME/.dotfiles/neovim/dracula.vim $HOME/.config/nvim/colors/

# Run neovim and install plugins
nvim --headless +PlugInstall +qall

exit 0

