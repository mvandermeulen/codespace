#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

CARGO_PACKAGES="cargo-watch cargo-binstall jless ouch exa hgrep lsd du-dust tokei hwatch"
CARGO_LOCKED_PACKAGES="zellij navi"
CARGO_BINSTALL_PACKAGES="sheldon"

cargo-install() {
	cargo install "$@"
    if [ $? -gt 0 ]; then
        sudo cargo install "$@"
    fi
}

cargo-install-locked() {
	cargo install --locked "$@"
    if [ $? -gt 0 ]; then
        sudo cargo install --locked "$@"
    fi
}

cargo-binstall() {
	cargo binstall "$@"
    if [ $? -gt 0 ]; then
        cargo install --locked "$@"
    fi
}

for item in $CARGO_PACKAGES; do
    cargo-install "$item"
done

for item in $CARGO_LOCKED_PACKAGES; do
    cargo-install-locked "$item"
done

for item in $CARGO_BINSTALL_PACKAGES; do
    cargo-binstall "$item"
done

exit 0