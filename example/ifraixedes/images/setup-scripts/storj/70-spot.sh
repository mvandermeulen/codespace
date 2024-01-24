#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="1.12.0"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="spot"
readonly DOWNLOAD_URL="https://github.com/umputun/spot/releases/download/v${VERSION}/spot_v${VERSION}_linux_x86_64.tar.gz"

TMP_DIR=$(mktemp -d)
readonly TMP_DIR
cleanup() {
	trap - EXIT

	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${TMP_DIR}/${BIN_NAME}.tgz" \
	"${DOWNLOAD_URL}"

cd "${TMP_DIR}"
tar zxf "${BIN_NAME}.tgz"
chmod +x "${BIN_NAME}" "${BIN_NAME}-secrets"
mv "${BIN_NAME}" "${BIN_NAME}-secrets" "${INSTALLATION_DIR}/"
