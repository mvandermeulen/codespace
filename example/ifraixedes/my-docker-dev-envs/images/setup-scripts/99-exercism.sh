#!/usr/bin/env -S bash -

set -eux -o pipefail

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/exercism.tgz" \
	"https://github.com/exercism/cli/releases/download/v3.0.13/exercism-linux-64bit.tgz"

cd "${tmp_dir}"
tar --no-same-owner -zxf "exercism.tgz"
chmod +x "exercism"
mv exercism "${installation_dir}/exercism"
