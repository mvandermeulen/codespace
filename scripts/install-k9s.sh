#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

# k9s install
curl -sS https://webinstall.dev/k9s | bash

exit 0