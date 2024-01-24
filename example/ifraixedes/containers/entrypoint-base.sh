#!/usr/bin/env zsh

# NOTES:
# This script assumes that it's executed in the same user home directory
cd ${HOME}

set -eu -o pipefail

source .my-env

# -u it's very important because for some reason TMUX doesn't read the UTF-8
# from the locale environment variables and it doesn't render some characters
# correctly. -u forces to use UTF-8
tmux -u
