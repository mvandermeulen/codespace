#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION=3.7.3
readonly INSTALLATION_DIR=/apps
mkdir -p ${INSTALLATION_DIR}

readonly BIN_NAME="sops"
readonly DOWNLOAD_URL="https://github.com/mozilla/sops/releases/download/v${VERSION}/sops-v${VERSION}.linux"

curl --fail -L \
	-o "${INSTALLATION_DIR}/${BIN_NAME}" \
	"${DOWNLOAD_URL}"

chmod +x "${INSTALLATION_DIR}/${BIN_NAME}"
