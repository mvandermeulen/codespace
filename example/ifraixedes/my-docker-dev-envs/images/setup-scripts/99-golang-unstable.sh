#!/usr/bin/env bash

set -eux -o pipefail

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail \
	-o "${tmp_dir}/golang.tar.gz" \
	"https://dl.google.com/go/go1.13beta1.linux-amd64.tar.gz"
tar -C "${installation_dir}" --no-same-owner -xzf "${tmp_dir}/golang.tar.gz"

# Install tools usually used for Go development
apt-get install -y graphviz
