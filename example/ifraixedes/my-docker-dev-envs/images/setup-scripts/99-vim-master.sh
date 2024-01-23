#!/usr/bin/env bash

set -eux -o pipefail

## Install C / C++ tools
apt-get install -y make gcc ncurses-dev python3-dev

## Clone VIM dir, compile it and install it
TMP_DIR=$(mktemp -d -t vim.XXXXXXXXXX)
cleanup() {
	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

pushd "${TMP_DIR}"

git clone https://github.com/vim/vim.git
cd vim/src/

./configure \
	--with-features=huge \
	--enable-gui=no \
	--enable-pythoninterp \
	--enable-python3interp \
	--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
	--enable-rubyinterp
make
make install

## Install current plugins requirements
# Required by github.com/Shougo/deoplete.nvim
apt-get install -y python3-pip
pip3 install neovim
