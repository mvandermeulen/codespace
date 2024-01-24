#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}


apt-get update 
apt-get install -y \
	build-essential \
	python-pip \
	python-dev \
	postgresql-server-dev-9.6 \
	git

pip install pgcli

apt-get purge python-dev postgresql-server-dev-9.6 build-essential git -y
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*