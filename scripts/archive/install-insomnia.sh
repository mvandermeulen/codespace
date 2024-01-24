#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

# Insomnia
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" \
    | sudo bash -c "tee -a /etc/apt/sources.list.d/insomnia.list"
sudo bash -c "apt update && apt install insomnia -y"

exit 0