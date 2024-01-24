#!/bin/bash

info() {
	echo -n "install rust language"
}

run() {
    export RUSTUP_HOME="$HOME/.rustup"
    export CARGO_HOME="$HOME/.cargo"

    _install_rust $1
    _install_rust_dependencies $1 $CARGO_HOME
}

_install_rust() {
    curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
}

_install_rust_dependencies() {
    local cargo_binary="$2/bin/cargo"

    print_message $1 "install useful plugins"
	$cargo_binary install cargo-edit cargo-expand
    $cargo_binary install tokei # statistics about your codes
    $cargo_binary install --features=ssl websocat # webSocket client
    $cargo_binary install bandwhich # displaying network utilization
    $cargo_binary install dua-cli  # disk Usage Analyzer
}
