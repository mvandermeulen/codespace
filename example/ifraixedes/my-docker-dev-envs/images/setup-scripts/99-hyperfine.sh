#!/usr/bin/env bash

set -eux -o pipefail

version="1.11.0"

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/hyperfine.tgz" \
	"https://github.com/sharkdp/hyperfine/releases/download/v${version}/hyperfine-v${version}-i686-unknown-linux-gnu.tar.gz"

cd "${tmp_dir}"
tar -zxf "hyperfine.tgz" --strip-components 1 --no-same-owner
chmod +x "hyperfine"
mv hyperfine "${installation_dir}/hyperfine"
