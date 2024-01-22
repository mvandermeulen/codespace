#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

# Re-adding Dotnet since I want to continue working w/ it.  And I want to mess around with the Xbox...
# note: Xbox maybe a no-go. It looks like we need version 5 of dotnet, but Mint 22 doesn't have openssl version 1 (it has version 3)
# which is needed by that version of .NET.  Same fuckery we have with older versions of Ruby. Niiiiiiice.  
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --version latest
echo "
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$PATH" >> ~/.bashrc
source ~/.bashrc
dotnet new --install Uno.ProjectTemplates.Dotnet
dotnet tool install -g uno.check
$DOTNET_ROOT/tools/uno-check --non-interactive

install_dotnet() {
   wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
   chmod +x ./dotnet-install.sh
   ./dotnet-install.sh --version latest
   rm dotnet-install.sh
}

## dotnet - With dotnet-install
# Mais sobre: <https://docs.microsoft.com/pt-br/dotnet/core/tools/dotnet-install-script>
wget https://dot.net/v1/dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh -c Current
./dotnet-install.sh -c 6.0
./dotnet-install.sh -c 5.0
./dotnet-install.sh -c 3.1

install_dotnet

exit 0