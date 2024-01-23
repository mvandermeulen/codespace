#!/usr/bin/env bash

set -eux -o pipefail

version=0.2.3

installation_dir=/apps
mkdir -p "${installation_dir}"

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

print_script_name() {
	basename "${0}"
}
trap print_script_name ERR

curl --fail --fail-early -L \
	-o "${tmp_dir}/ijq.tgz" \
	"https://git.sr.ht/~gpanders/ijq/refs/download/v${version}/ijq-${version}-linux-x86_64.tar.gz"

cd "${tmp_dir}"
tar -zxf "ijq.tgz" --strip-components 1 --no-same-owner
chmod +x "${tmp_dir}/ijq"
mv ijq "${installation_dir}/ijq"
