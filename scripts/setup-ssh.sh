#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}


# ssh-keygen
if [ ! -e ~/.ssh ] ; then
	mkdir ~/.ssh
	ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
	cat ~/.ssh/id_rsa.pub
	echo "Set up your git config username and email address with the following command" > /dev/null
	echo "git config --global user.name [name]" > /dev/null
	echo "git config --global user.email [address]" > /dev/null
	echo "Then, after setting up the public key on github, please confirm communication using the following command" > /dev/null
	echo "ssh -T git@github.com" > /dev/null
fi

exit 0