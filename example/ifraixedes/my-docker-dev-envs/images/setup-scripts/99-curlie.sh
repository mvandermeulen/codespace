#!/usr/bin/env bash

set -eux -o pipefail

version="1.6.0"

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/curlie.tgz" \
	"https://github.com/rs/curlie/releases/download/v${version}/curlie_${version}_linux_amd64.tar.gz"

tar -C "${tmp_dir}" --no-same-owner -xzf "${tmp_dir}/curlie.tgz"
mv "${tmp_dir}/curlie" "${installation_dir}"
chmod +x "${installation_dir}/curlie"
