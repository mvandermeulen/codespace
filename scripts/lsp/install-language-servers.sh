#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

LANGUAGE_SERVER_PACKAGES="typescript-language-server svelte-language-server bash-language-server dockerfile-language-server-nodejs vscode-html-languageserver-bin pyright yaml-language-server"

npm-install() {
	npm install -g "$@"
}

for item in $LANGUAGE_SERVER_PACKAGES; do
	npm-install "$item"
done

exit 0