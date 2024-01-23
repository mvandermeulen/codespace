#!/bin/env bash

temp=$( realpath "$0"  )
CURRENT_DIR=$(dirname "$temp")

if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/shims:$PATH"
  eval "$(rbenv init -)"
fi

file_path="${CURRENT_DIR}/../ruby/parse_webpage.rb"

NVM_VERSION=$(ruby "$file_path" "https://github.com/nvm-sh/nvm")

echo "NVM version:-> ${NVM_VERSION}"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v"${NVM_VERSION}"/install.sh | bash
