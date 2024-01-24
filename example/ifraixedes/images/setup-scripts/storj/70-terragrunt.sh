#!/usr/bin/env bash

set -eux -o pipefail

readonly VERSION="0.45.3"
readonly INSTALLATION_DIR="/apps"
mkdir -p "${INSTALLATION_DIR}"

readonly BIN_NAME="terragrunt"
readonly DOWNLOAD_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${VERSION}/terragrunt_linux_amd64"

curl --fail -L \
	-o "${INSTALLATION_DIR}/${BIN_NAME}" \
	"${DOWNLOAD_URL}"

chmod +x "${INSTALLATION_DIR}/${BIN_NAME}"
