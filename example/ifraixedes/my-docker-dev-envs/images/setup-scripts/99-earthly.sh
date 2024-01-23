#!/usr/bin/env -S bash -

set -eux -o pipefail

version=0.3.8

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail -L \
	-o "${installation_dir}/earthly" \
	"https://github.com/earthly/earthly/releases/download/v${version}/earth-linux-amd64"

chmod +x "${installation_dir}/earthly"
