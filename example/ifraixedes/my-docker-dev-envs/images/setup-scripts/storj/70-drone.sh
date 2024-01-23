#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION=latest
readonly INSTALLATION_DIR=/apps
mkdir -p ${INSTALLATION_DIR}

readonly BIN_NAME="drone"
readonly DONWLOAD_URL="https://github.com/drone/drone-cli/releases/${VERSION}/download/drone_linux_amd64.tar.gz"

TMP_DIR=$(mktemp -d)
readonly TMP_DIR
cleanup() {
	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${TMP_DIR}/${BIN_NAME}.tgz" \
	"${DONWLOAD_URL}"

cd "${TMP_DIR}"
tar xzf "${TMP_DIR}/${BIN_NAME}.tgz" --no-same-owner
chmod +x "${BIN_NAME}"
mv "${BIN_NAME}" "${INSTALLATION_DIR}/"
