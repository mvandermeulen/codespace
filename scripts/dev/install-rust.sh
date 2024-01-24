#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs -o "$INSTALL_PATH/sh.rustup.rs" \
    && chmod +x "$INSTALL_PATH/sh.rustup.rs" \
    && $INSTALL_PATH/sh.rustup.rs --default-toolchain none -y \
    && rm -rf "$INSTALL_PATH/sh.rustup.rs" \
    && . "$HOME"/.cargo/env \
    && rustup toolchain install stable \
    # && rustup component add rust-analyzer rust-src \
    && rustup component add rust-analyzer \
    && rustup component add rust-src --toolchain "$toolchain" # required for goto source to work with the standard library

exit 0