#!/usr/bin/env bash

set -eux -o pipefail

version="0.7.1"

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/shellcheck.tar.xz" \
	"https://github.com/koalaman/shellcheck/releases/download/v${version}/shellcheck-v${version}.linux.x86_64.tar.xz"

cd "${tmp_dir}"
xz -d shellcheck.tar.xz
tar xf "shellcheck.tar" --strip-components 1
chmod +x "shellcheck"
mv shellcheck "${installation_dir}/"
