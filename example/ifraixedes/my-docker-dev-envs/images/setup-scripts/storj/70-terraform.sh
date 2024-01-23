#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="1.3.4"
readonly INSTALLATION_DIR=/apps
mkdir -p ${INSTALLATION_DIR}

readonly BIN_NAME="terraform"
readonly DONWLOAD_URL="https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"

TMP_DIR=$(mktemp -d)
readonly TMP_DIR
cleanup() {
	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

curl --fail -L \
	-o "${TMP_DIR}/${BIN_NAME}.zip" \
	"${DONWLOAD_URL}"

unzip -j "${TMP_DIR}/${BIN_NAME}.zip" -d "${INSTALLATION_DIR}"
chmod +x "${INSTALLATION_DIR}/${BIN_NAME}"
