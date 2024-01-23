#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION=2.30.0
readonly INSTALLATION_DIR=/apps
mkdir -p ${INSTALLATION_DIR}

readonly BIN_NAME="promtool"
readonly DONWLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz"

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
tar xzf "${TMP_DIR}/${BIN_NAME}.tgz" --no-same-owner --strip-components 1
chmod +x "${BIN_NAME}"
mv "${BIN_NAME}" "${INSTALLATION_DIR}/"
