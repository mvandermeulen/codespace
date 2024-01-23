#!/usr/bin/env bash

set -eux -o pipefail

version=1.26.1

installation_dir=/apps
mkdir -p ${installation_dir}

curl --fail -L \
	-o "${installation_dir}/kubectl" \
	"https://storage.googleapis.com/kubernetes-release/release/v${version}/bin/linux/amd64/kubectl"
chmod +x "${installation_dir}/kubectl"

# krew: kubectl plugins manager
(
	set -x
	cd "$(mktemp -d)" &&
		OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
		ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
		KREW="krew-${OS}_${ARCH}" &&
		curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
		tar zxvf "${KREW}.tar.gz" &&
		./"${KREW}" install krew
)

# install the following plugins with krew
PATH="${installation_dir}:${HOME}/.krew/bin:${PATH}"
kubectl krew install fuzzy

# plugins to a directory that's shared across user
mv "${HOME}/.krew" "${installation_dir}/krew"
chmod 755 -R "${installation_dir}/krew"

# replace symlinks with absolute path for relative path to make them valid again
pushd "${installation_dir}/krew/bin"
for l in ./*; do
	ap=$(stat "${l}" | grep -i "file:" | cut -d '>' -f 2)
	rp=${ap#*".krew"}
	fname=$(basename "${l}")
	rm "${fname}"
	ln -s "..${rp}" "${fname}"
done
