#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")")
. "$SETUP_ROOT/config.txt" || exit 1

# check for errors on exit
on_exit() {
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "Setup failed"
  fi
}
trap on_exit EXIT

# perform all the set up steps required for a unix user
"$SETUP_ROOT/user/nix/setup-apt.sh" || exit 1
"$SETUP_ROOT/user/nix/setup-git.sh" || exit 1
"$SETUP_ROOT/user/nix/setup-ssh.sh" || exit 1
"$SETUP_ROOT/user/nix/setup-gpg.sh" || exit 1
"$SETUP_ROOT/user/nix/setup-python.sh" || exit 1
"$SETUP_ROOT/user/nix/setup-git-remote.sh" || exit 1
"$SETUP_ROOT/user/nix/setup-jetbrains.sh" || exit 1
