#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

RUST_PACHAGES="cargo-watch jless ouch zellij"


cargo-install() {
	cargo install "$@"
    if [ $? -gt 0 ]; then
        sudo cargo install "$@"
    fi
}



