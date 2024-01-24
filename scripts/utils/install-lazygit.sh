#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

DOWNLOAD_BASE_URL="https://github.com/jesseduffield/lazygit/releases/download"
LAZYGIT_VERSION="v0.40.2"
LAZYGIT_INSTALLER_ARCHIVE="lazygit_0.40.2_Linux_arm64.tar.gz"

curl -Lo "${INSTALL_PATH}/${LAZYGIT_INSTALLER_ARCHIVE}" "${DOWNLOAD_BASE_URL}/${LAZYGIT_VERSION}/${LAZYGIT_INSTALLER_ARCHIVE}"
tar -xzf "${INSTALL_PATH}/${LAZYGIT_INSTALLER_ARCHIVE}" -C "$HOME/.local/bin" && rm -f "${INSTALL_PATH}/${LAZYGIT_INSTALLER_ARCHIVE}"

# install_lazygit() {
    
#     if [ "$architecture" = "aarch64" ]; then
#         mkdir tmp && cd tmp
#         curl -Lo lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_arm64.tar.gz
#         tar xf lazygit.tar.gz lazygit
#         mv lazygit ~/.local/bin
#         cd .. && rm -rf tmp
#     else 
#         mkdir tmp && cd tmp
#         LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
#         curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
#         tar xf lazygit.tar.gz lazygit
#         mv lazygit ~/.local/bin
#         rm lazygit.tar.gz
#         cd .. && rm -rf tmp
#     fi
  
# }

exit 0