#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

# Act - Run GitHub Workflow
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
sudo bash -c "mv bin/act /usr/local/bin"

exit 0