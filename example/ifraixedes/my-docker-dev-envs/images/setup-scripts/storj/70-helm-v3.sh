#!/usr/bin/env -S bash -

set -eux -o pipefail

helm_version="3.4.1"
installation_dir=/apps
mkdir -p ${installation_dir}

tmp_dir=$(mktemp -d)
cleanup() {
	rm -rf "${tmp_dir}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${tmp_dir}/helm.tgz" \
	"https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz"

curl --fail -L \
	-o "${tmp_dir}/helm.sha256" \
	"https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz.sha256"

cd "${tmp_dir}"
sha=$(cat helm.sha256)
calculated_sha=$(sha256sum helm.tgz | cut -d ' ' -f 1)
if [[ "${sha}" != "${calculated_sha}" ]]; then
	echo "Invalid Helm checksum"
	exit 1
fi

tar --no-same-owner -xzf helm.tgz
chmod +x linux-amd64/helm
mv linux-amd64/helm ${installation_dir}/helm3
