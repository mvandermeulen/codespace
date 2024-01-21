#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

GOLANG_PACKAGES="golang.org/x/tools/gopls@latest mvdan.cc/gofumpt@latest github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest github.com/ramya-rao-a/go-outline@latest github.com/cweill/gotests/gotests@latest github.com/fatih/gomodifytags@latest github.com/josharian/impl@latest github.com/haya14busa/goplay/cmd/goplay@latest github.com/go-delve/delve/cmd/dlv@latest honnef.co/go/tools/cmd/staticcheck@latest"

go-install() {
	go install "$@"
}

for item in $GOLANG_PACKAGES; do
    go-install "$item"
done


exit 0