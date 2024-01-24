#!/usr/bin/env bash

set -eux -o pipefail

version=0.23.0

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail -L \
	-o "${installation_dir}/kubie" \
	"https://github.com/sbstp/kubie/releases/download/v${version}/kubie-linux-amd64"

chmod +x "${installation_dir}/kubie"
