#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
NVM_VERSION=${NVM_VERSION:-"0.39.1"}

NODE_INSTALL_VERSIONS="node --lts"
NODE_USE_VERSION="--lts"

nvm-install() {
	nvm install "$@"
}


# Install node version manager
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm ' >> $HOME/.zshrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> $HOME/.zshrc \
    && source $HOME/.nvm/nvm.sh

# nvm install 16
# nvm alias default stable

# Install yarn without nodejs. The package being at the system-level means it
# will still be available if you switch node version.
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends -y yarn

for item in $NODE_INSTALL_VERSIONS; do
	nvm-install "$item"
done
# nvm-install "node"
# nvm-install "--lts"

nvm use --lts
nvm use "$NODE_USE_VERSION"

# curl --create-dirs -o "$HOME/.local/share/bash-completion/yarn" \
# 	https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
# echo '. ~/.local/share/bash-completion/yarn' >> ~/.bashrc

# customize fzf to ignore node_modules
# cat /tmp/bashrc-additions.sh >> ~/.bashrc
# sudo rm /tmp/bashrc-additions.sh

exit 0