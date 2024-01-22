#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz

tar -xf vscode_cli.tar.gz
screen -dm /root/opt/vscode/code tunnel
code tunnel
code tunnel service install

sudo cp ~/.vscode-cli/code-tunnel.service /etc/systemd/system/
systemctl --user daemon-reload
systemctl --user enable code-tunnel.service
systemctl --user status

exit 0