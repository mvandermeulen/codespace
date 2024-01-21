#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

NODE_NPM_PACKAGES="npm yarn pnpm eslint prettier typescript"
NODE_YARN_PACKAGES=""

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

for item in $NODE_YARN_PACKAGES; do
	yarn-install "$item"
done

# yarn global add flip-table
# sudo rm -rf ~/.cache/yarn/*


exit 0