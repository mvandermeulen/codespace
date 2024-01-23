#!/bin/bash

devenv_directory="${1:-$HOME/Documents/workspace/devenv}"
mkdir -p "$(dirname $devenv_directory)"
git clone https://github.com/mohammadne/devenv.git $devenv_directory
cd $devenv_directory && git remote set-url origin git@github.com:mohammadne/devenv.git
