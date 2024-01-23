#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="0.5.8"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="mcfly"
readonly DOWNLOAD_URL="https://github.com/cantino/mcfly/releases/download/v${VERSION}/mcfly-v${VERSION}-x86_64-unknown-linux-musl.tar.gz"

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
chmod +x "${BIN_NAME}"
mv "${BIN_NAME}" "${INSTALLATION_DIR}/"
