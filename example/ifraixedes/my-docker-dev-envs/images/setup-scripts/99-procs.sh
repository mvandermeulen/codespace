#!/usr/bin/env bash

set -eux -o pipefail

version="0.11.3"

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/procs.zip" \
	"https://github.com/dalance/procs/releases/download/v${version}/procs-v${version}-x86_64-lnx.zip"
unzip -j "${tmp_dir}/procs.zip" -d "${installation_dir}"
chmod +x "${installation_dir}/procs"
