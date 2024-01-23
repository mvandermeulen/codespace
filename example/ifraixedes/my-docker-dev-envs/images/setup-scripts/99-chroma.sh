#!/usr/bin/env bash

set -eux -o pipefail

version="0.9.2"

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/chroma.tgz" \
	"https://github.com/alecthomas/chroma/releases/download/v${version}/chroma-${version}-linux-amd64.tar.gz"

tar -C "${tmp_dir}" --no-same-owner -xzf "${tmp_dir}/chroma.tgz"
mv "${tmp_dir}/chroma" "${installation_dir}"
chmod +x "${installation_dir}/chroma"
