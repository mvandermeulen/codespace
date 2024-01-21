#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

sudo apt-get update
apt-install luarocks
apt-install lua-yaml

luarocks install dkjson --local \
    && luarocks install say --local \
    && luarocks install checks --local \
    && luarocks --server=http://rocks.moonscript.org install lyaml --local

exit 0