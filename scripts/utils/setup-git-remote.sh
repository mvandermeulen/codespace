#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

# remote git configuration needs to run after ssh and gpg configuration

remote_git_works() {
  ssh -qT \
    -o"BatchMode yes" \
    -o"StrictHostKeyChecking accept-new" \
    "git@$REMOTE_GIT_HOST" 1> /dev/null 2>&1
  if [ $? -eq 255 ]; then
    return 1
  else
    return 0
  fi
}

while ! remote_git_works
do
  # remote git authentication with ssh isn't set up yet,
  # prompt the user to add their key
  SSH_DIR=~/.ssh
  PRIV_KEY="$SSH_DIR/id_$SSH_ALGO"
  PUB_KEY="$PRIV_KEY.pub"

  echo
  echo
  echo "To enable SSH authentication to $REMOTE_GIT_HOST, copy the following"
  echo "key and paste it into the SSH key management configuration on "
  echo "$REMOTE_GIT_HOST."
  echo ""
  cat "$PUB_KEY"
  echo ""
  echo "Please visit https://$REMOTE_GIT_HOST/$REMOTE_GIT_SSH_ADMIN and add the"
  echo "above key (use any label you like). Please return to this window and"
  echo "press enter to confirm that the operation was successful."
  read -r _

  # if a GPG key exists prompt the user to add it to the remote git (there's no
  # way to tell if this was already done)
  GPG_KEY_ID="$(gpg --list-secret-keys --keyid-format LONG 2> /dev/null | grep -h 'sec' | sed -e 's=.*/==g' | awk '{ print $1 }' | head -n 1)"
  if [ -n "$GPG_KEY_ID" ]; then
    GPG_KEY="$(gpg --armor --export "$GPG_KEY_ID")"
    echo
    echo
    echo "To enable validation of GPG commit signatures on $REMOTE_GIT_HOST, copy"
    echo "the following key and paste it into the key management configuration on"
    echo "$REMOTE_GIT_HOST."
    echo ""
    echo "$GPG_KEY"
    echo ""
    echo "Please visit https://$REMOTE_GIT_HOST/$REMOTE_GIT_GPG_ADMIN and add"
    echo "the above key (use any label/title you like). Note that you may"
    echo "already have registered key $GPG_KEY_ID on $REMOTE_GIT_HOST, in which"
    echo "case you can skip this step."
    echo
    echo "Press enter to continue."
    read -r _
  fi
done

exit 0
