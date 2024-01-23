#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="1.16.2"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="deno"
readonly DOWNLOAD_URL="https://github.com/denoland/deno/releases/download/v${VERSION}/deno-x86_64-unknown-linux-gnu.zip"

TMP_DIR=$(mktemp -d)
readonly TMP_DIR
cleanup() {
	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${TMP_DIR}/${BIN_NAME}.zip" \
	"${DOWNLOAD_URL}"

unzip -j "${TMP_DIR}/${BIN_NAME}.zip" -d "${INSTALLATION_DIR}"
chmod +x "${INSTALLATION_DIR}/${BIN_NAME}"
