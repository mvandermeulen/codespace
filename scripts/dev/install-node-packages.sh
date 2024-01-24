#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

NODE_NPM_PACKAGES="npm yarn pnpm eslint eslint_d prettier stylelint eslint-config-prettier eslint-plugin-prettier prettier-eslint-cli htmlhint uuid-cli"
NODE_YARN_PACKAGES=""

NODE_NVIM_PACKAGES="typescript typescript-language-server neovim tree-sitter-cli"

npm-install() {
	npm install -g "$@"
}

yarn-install() {
	yarn install -g "$@"
}

npm-install "yarn"

for item in $NODE_NPM_PACKAGES; do
	npm-install "$item"
done

for item in $NODE_NVIM_PACKAGES; do
	npm-install "$item"
done

for item in $NODE_YARN_PACKAGES; do
	yarn-install "$item"
done

# yarn global add flip-table
# sudo rm -rf ~/.cache/yarn/*


exit 0