#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

# set up python related commands
# needs to run after apt configuration
pipx ensurepath 1> /dev/null 2>&1

pipx_install() {
  pkg="$1"
  if [ ! -x "$(which "$pkg")" ]; then
    echo "installing $pkg with pipx"
    pipx install "$pkg" > /dev/null
  fi
}

pipx_install pre-commit
pipx_install cookiecutter

# set up pre-commit to be automatically active for all repositories that have a configuration
if [ ! -f "$GIT_TEMPLATE_DIR/hooks/pre-commit" ]; then
  ~/.local/bin/pre-commit init-templatedir "$GIT_TEMPLATE_DIR"
fi

exit 0
