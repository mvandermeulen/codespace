#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

# if we have gpg keys already, there's nothing to do
GPG_KEY_EXISTS="$(gpg --list-secret-keys --keyid-format LONG 2> /dev/null)"
if [ -n "$GPG_KEY_EXISTS" ]; then
  exit 0
fi

# create a GPG key with empty passowrd. First of all, we need the user ID, so
# try generating it from git settings, otherwise prompt
USER_NAME="$(git config --global user.name)"
USER_EMAIL="$(git config --global user.email)"
while [ -z "$USER_NAME" ] || [ -z "$USER_EMAIL" ]; do
  # keep asking for user name and email until we get something
  echo "Please input the full name you would like to associate to your GPG key."
  echo "Example: $EXAMPLE_NAME: "
  read -r USER_NAME

  echo "Please input the email you would like to associate to your GPG key."
  echo "Example: $EXAMPLE_EMAIL: "
  read -r USER_EMAIL
done

# generate the gpg key
USER_ID="$USER_NAME <${USER_EMAIL}>"
echo "generating GPG key for $USER_ID"
gpg --quick-generate-key --batch \
  --passphrase "$GPG_PASSPHRASE" \
  "$USER_ID" "$GPG_ALGO" "$GPG_USAGE" "$GPG_EXPIRY" > /dev/null 2>&1 || exit 1


# if git is installed and not yet configured with a signing key, set it up to
# sign usign the newly generated key
if [ -x "$(which git)" ] && [ -z "$(git config --global user.signingkey)" ]; then
  # grab the identifier of the first key
  GPG_KEY_ID="$(gpg --list-secret-keys --keyid-format LONG 2> /dev/null | grep -h 'sec' | sed -e 's=.*/==g' | awk '{ print $1 }' | head -n 1)"
  if [ -n "$GPG_KEY_ID" ]; then
    echo "Setting up git commit signing using GPG key $GPG_KEY_ID"
    git config --global user.signingkey "$GPG_KEY_ID"
    git config --global commit.gpgsign true
  fi
fi

exit 0
