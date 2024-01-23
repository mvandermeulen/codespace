#!/usr/bin/env bash

set -eux -o pipefail

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail -L \
	-o "${installation_dir}/kubectl" \
	"https://storage.googleapis.com/kubernetes-release/release/v1.15.12/bin/linux/amd64/kubectl"
chmod +x "${installation_dir}/kubectl"
