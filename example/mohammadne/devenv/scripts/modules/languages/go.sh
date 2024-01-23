#!/bin/bash

info() {
	echo -n "install and config Go language"
}

run() {
	local go_root="/usr/local/go"

    _install_go $1 $go_root
    _config_go $1 $go_root
	_install_go_dependencies $1 $go_root
}

_install_go() {
    local version="1.21.5"
    local url="https://go.dev/dl/go${version}.linux-amd64.tar.gz"

    if check_versioned_binary $1 "$2/bin/go" $version "version"; then return; fi
    if ! result=$(download_file $1 $url); then echo "$result" && return 1; fi
    sudo rm -rf $2 && sudo tar -C $(dirname $2) -xzf $result && rm -rf "$result"
}

_config_go() {
	local go_binary="$2/bin/go"

	print_message $1 "set go environments"
    $go_binary env -w GOPATH="$HOME/.go"
	$go_binary env -w GOPROXY="https://goproxy.io,goproxy.cn,direct"
	$go_binary env -w GONOSUMDB="git.cafebazaar.ir"
	$go_binary env -w GOPRIVATE="git.cafebazaar.ir"
}

_install_go_dependencies() {
	local go_binary="$2/bin/go"

	$go_binary install golang.org/x/tools/gopls@latest # Language server from google
	$go_binary install github.com/cweill/gotests/gotests@v1.6.0 # Generate unit tests
	$go_binary install github.com/fatih/gomodifytags@v1.16.0 # Modify tags on structs
	$go_binary install github.com/josharian/impl@v1.1.0 # Stubs for interfaces
	$go_binary install github.com/haya14busa/goplay/cmd/goplay@v1.0.0 # The Go playground
	$go_binary install github.com/go-delve/delve/cmd/dlv@latest # Go debugger (Delve)
	$go_binary install honnef.co/go/tools/cmd/staticcheck@latest # Linter
	# require_go github.com/golangci/golangci-lint/cmd/golangci-lint
	# require_go mvdan.cc/gofumpt
	# require_go golang.org/x/tools/cmd/goimports
	# require_go golang.org/dl/gotip

	print_message $1 "install useful dependencies"
	$go_binary install github.com/onsi/ginkgo/v2/ginkgo@v2.11.0
	$go_binary install github.com/charmbracelet/glow@latest # render markdown
	$go_binary install github.com/mikefarah/yq/v4@latest

}
