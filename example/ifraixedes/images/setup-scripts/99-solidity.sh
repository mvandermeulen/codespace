#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="0.8.18"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="solc"
readonly DOWNLOAD_URL="https://github.com/ethereum/solidity/releases/download/v${VERSION}/solc-static-linux"

curl --fail -L \
	-o "${INSTALLATION_DIR}/${BIN_NAME}" \
	"${DOWNLOAD_URL}"

chmod +x "${INSTALLATION_DIR}/${BIN_NAME}"
