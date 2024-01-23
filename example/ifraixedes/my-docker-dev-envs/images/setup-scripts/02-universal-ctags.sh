#!/usr/bin/env bash

set -eux -o pipefail

installation_dir="/usr/local"
mkdir -p "${installation_dir}"

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

pushd "${tmp_dir}"

# Install dependencies for building ctags.
apt-get -y install \
	gcc make \
	pkg-config autoconf automake \
	python3-docutils \
	libseccomp-dev \
	libjansson-dev \
	libyaml-dev \
	libxml2-dev

git clone https://github.com/universal-ctags/ctags.git

pushd ctags
./autogen.sh
./configure --prefix="${installation_dir}"
make
make install

popd
popd
