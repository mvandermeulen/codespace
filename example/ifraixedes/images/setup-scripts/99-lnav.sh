#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="0.10.1"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="lnav"
readonly DOWNLOAD_URL="https://github.com/tstack/lnav/releases/download/v${VERSION}/lnav-${VERSION}-musl-64bit.zip"

TMP_DIR=$(mktemp -d)
readonly TMP_DIR
cleanup() {
	trap - EXIT

	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${TMP_DIR}/${BIN_NAME}.zip" \
	"${DOWNLOAD_URL}"

cd "${TMP_DIR}"
unzip -j "${BIN_NAME}.zip" "*/lnav" -d "${INSTALLATION_DIR}"
