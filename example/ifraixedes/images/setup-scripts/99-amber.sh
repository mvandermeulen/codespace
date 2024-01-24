#!/usr/bin/env bash

set -eux -o pipefail

installation_dir=/apps
mkdir -p "${installation_dir}"

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/amber.zip" \
	"https://github.com/dalance/amber/releases/download/v0.5.3/amber-v0.5.3-x86_64-lnx.zip"

unzip -j "${tmp_dir}/amber.zip" -d ${installation_dir}
