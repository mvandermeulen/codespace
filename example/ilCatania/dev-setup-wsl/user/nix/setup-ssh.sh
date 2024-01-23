#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

SSH_DIR=~/.ssh
PRIV_KEY="$SSH_DIR/id_$SSH_ALGO"
PUB_KEY="$PRIV_KEY.pub"

if [ ! -f "$PRIV_KEY" ] || [ ! -f "$PUB_KEY" ]; then
  # generate public/private key pair with no password for use in bitbucket
  echo "generating public/private SSH key pair"
  ssh-keygen -q -t "$SSH_ALGO" -b "$SSH_BYTES" -N "$SSH_PASSPHRASE" -f "$PRIV_KEY"
fi

SSH_CFG="$SSH_DIR/config"
if [ ! -f "$SSH_CFG" ]; then
  echo "creating user ssh configuration"
  cp "$SETUP_ROOT/user/config/ssh" "$SSH_CFG"
fi

exit 0
