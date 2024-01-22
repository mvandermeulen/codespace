#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

### login to Docker hub ###
# NOTE: it is assumed that only the root user is intended to access the Docker deamon
# NOTE: https://github.com/docker/docker-credential-helpers/issues/140
curl -o /usr/bin/docker-credential-pass -LO $(curl -s https://api.github.com/repos/docker/docker-credential-helpers/releases/latest | grep browser_download_url | grep docker-credential-pass | grep linux-amd64 | cut -d '"' -f 4)
chmod a+x /usr/bin/docker-credential-pass # TODO: do I need it?
gpg --generate-key # create a key to encrypt the Docker access token
pass init $(gpg -k | awk 'NR==4 { print $1 }') # use this gpg public key to encrypt the access token
echo 'Use your access token as password'
docker login --username tapyu

exit 0