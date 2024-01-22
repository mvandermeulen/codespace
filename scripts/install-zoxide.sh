#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

BOTTOM_VERSION="0.9.6"
BOTTOM_INSTALLER_NAME="bottom_0.9.6_amd64.deb"

curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
eval "$(zoxide init bash)"

exit 0