#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="0.11.0"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="zig"
readonly DOWNLOAD_URL="https://ziglang.org/download/${VERSION}/zig-linux-x86_64-${VERSION}.tar.xz"

TMP_DIR=$(mktemp -d)
readonly TMP_DIR

curl --fail -L \
	-o "${TMP_DIR}/${BIN_NAME}.tar.xz" \
	"${DOWNLOAD_URL}"

pushd "${TMP_DIR}"
tar xf "${BIN_NAME}.tar.xz" --no-same-owner --strip-components=1
chmod +x "${BIN_NAME}"
popd
mv "${TMP_DIR}" "${INSTALLATION_DIR}/${BIN_NAME}"
chmod +rx "${INSTALLATION_DIR}/${BIN_NAME}"
