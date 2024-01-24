#!/usr/bin/env bash

set -eux -o pipefail

version=1.6.6

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/packer.zip" \
	"https://releases.hashicorp.com/packer/${version}/packer_${version}_linux_amd64.zip"

unzip -j "${tmp_dir}/packer.zip" -d "${installation_dir}"
chmod +x "${installation_dir}/packer"
