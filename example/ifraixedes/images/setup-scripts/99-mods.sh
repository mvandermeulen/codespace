#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="0.1.1"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="mods"
readonly DOWNLOAD_URL="https://github.com/charmbracelet/mods/releases/download/v${VERSION}/mods_Linux_x86_64.tar.gz"

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
tar zxf "${BIN_NAME}.tgz" --no-same-owner
chmod +x "${BIN_NAME}"
mv "${BIN_NAME}" "${INSTALLATION_DIR}/"
