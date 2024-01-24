#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

curl --output ~/src/microsoft.asc -fsSL https://packages.microsoft.com/keys/microsoft.asc
gpg --list-packets ~/src/microsoft.asc | grep "user ID"
# check key ID
sudo cp -v ~/src/microsoft.asc /usr/local/share/keyrings/microsoft.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/local/share/keyrings/microsoft.asc] https://packages.microsoft.com/ubuntu/$(lsb_release -rs)/prod $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/microsoft.list
sudo apt-get update
sudo apt-get install -y powershell
pwsh
exit

exit 0