#!/usr/bin/env bash

set -eux -o pipefail

version=1.14.1

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/watchexec.tgz" \
	"https://github.com/watchexec/watchexec/releases/download/${version}/watchexec-${version}-x86_64-unknown-linux-musl.tar.xz"

cd "${tmp_dir}"
tar -xf "watchexec.tgz" --strip-components 1 --no-same-owner
chmod +x "watchexec"
mv watchexec "${installation_dir}/watchexec"
