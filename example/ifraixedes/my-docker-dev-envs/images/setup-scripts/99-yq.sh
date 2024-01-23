#!/usr/bin/env -S bash -

set -eux -o pipefail

installation_dir=/apps
mkdir -p "${installation_dir}"

curl --fail -L \
	-o "${installation_dir}/yq" \
	"https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64"

chmod +x "${installation_dir}/yq"
