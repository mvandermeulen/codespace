#!/usr/bin/env bash

set -eux -o pipefail

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail \
	-o "${installation_dir}/rustup-init" \
	"https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"
chmod +x "${installation_dir}/rustup-init"
