#!/usr/bin/env bash

set -eux -o pipefail

version=22.2.5

installation_dir=/apps
mkdir -p "${installation_dir}"

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/cockroach.tgz" \
	"https://binaries.cockroachdb.com/cockroach-v${version}.linux-amd64.tgz"

cd "${tmp_dir}"
tar -zxf "cockroach.tgz" --strip-components 1 --no-same-owner
chmod +x "${tmp_dir}/cockroach"
mv cockroach "${installation_dir}/cockroach"
