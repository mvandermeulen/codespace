#!/usr/bin/env bash

set -eux -o pipefail

version="0.10.0"

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail -L \
	-o "${installation_dir}/kind" \
	"https://github.com/kubernetes-sigs/kind/releases/download/v${version}/kind-linux-amd64"
chmod +x "${installation_dir}"/kind
