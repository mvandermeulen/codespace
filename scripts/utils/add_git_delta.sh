#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

GITDELTAVERS="0.16.5"
GITDELTAURL="https://github.com/dandavison/delta/releases/download/${GITDELTAVERS}/git-delta_${GITDELTAVERS}_amd64.deb"

mkdir -p /usr/share/doc/git-delta-${GITDELTAVERS}
cd /usr/share/doc/git-delta-${GITDELTAVERS}
wget https://raw.githubusercontent.com/dandavison/delta/main/README.md
wget https://raw.githubusercontent.com/dandavison/delta/main/LICENSE
wget ${GITDELTAURL} -O git-delta.deb
dpkg -i git-delta.deb
rm git-delta.deb

exit 0

