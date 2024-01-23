#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION=1.41.1

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/golangci-lint.tgz" \
	"https://github.com/golangci/golangci-lint/releases/download/v${VERSION}/golangci-lint-${VERSION}-linux-amd64.tar.gz"

cd "${tmp_dir}"
tar -zxf "golangci-lint.tgz" --strip-components 1 --no-same-owner
chmod +x "golangci-lint"
mv golangci-lint "${installation_dir}/"
