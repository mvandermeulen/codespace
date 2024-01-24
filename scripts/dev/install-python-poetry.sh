#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

export POETRY_INSTALLER_MAX_WORKERS=8
curl -sSL https://install.python-poetry.org | python3 -

exit 0