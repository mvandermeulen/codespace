#!/usr/bin/env bash

set -eux -o pipefail

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/ripgrep.tgz" \
	"https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz"

cd "${tmp_dir}"
tar -zxf "ripgrep.tgz" --strip-components 1 --no-same-owner
chmod +x "rg"
mv rg "${installation_dir}/rg"
