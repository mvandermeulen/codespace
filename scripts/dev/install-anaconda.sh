#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

curl -o- "https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh" | bash

exit 0