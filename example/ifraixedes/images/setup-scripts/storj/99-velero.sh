#!/usr/bin/env bash

set -eux -o pipefail

version="1.4.2"

installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/velero.tgz" \
	"https://github.com/vmware-tanzu/velero/releases/download/v${version}/velero-v${version}-linux-amd64.tar.gz"

cd "${tmp_dir}"
tar -zxf "velero.tgz" --strip-components 1 --no-same-owner
chmod +x "velero"
mv velero "${installation_dir}/velero"
