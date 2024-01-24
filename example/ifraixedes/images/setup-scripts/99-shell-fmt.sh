#!/usr/bin/env -S bash -

set -eux -o pipefail

version=3.1.2

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail -L \
	-o "${installation_dir}/shfmt" \
	"https://github.com/mvdan/sh/releases/download/v${version}/shfmt_v${version}_linux_amd64"

chmod +x "${installation_dir}/shfmt"
