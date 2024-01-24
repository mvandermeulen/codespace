#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

exit 0