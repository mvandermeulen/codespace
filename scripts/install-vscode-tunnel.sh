#!/usr/bin/env bash

# This script installs VS Code CLI and enables the VS Code Tunnel Service.
# /bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/kevinderuijter/9d399166e0784efbacb2f566cb02ef68/raw/tunnel.sh)"

STEP=0
step() {
    STEP=$((STEP+1))
    echo -e "\e[32m[$STEP/3]\e[0m $1"
}

# Show error with given message and exit.
raise() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

# Make sure script is running without root permissions.
if [[ ${EUID} -eq 0 ]]; then
    raise "This script should not be run as root."
fi

# Make sure script is running on Linux.
if [[ $(uname -s) != "Linux" ]]; then
    raise "This script is only for Linux."
fi

# Make sure script is not running from a VS Code Tunnel.
if ps -p $$ -o ppid | tail -n 1 | ps -p "$(xargs)" -o args | grep -q .vscode; then
    raise "This script should not be run from a VS Code Tunnel."
fi

# Install VS Code.
if [[ ! -f ~/.local/bin/code ]]; then
    step "Installing VS Code CLI..."
    mkdir -p "$HOME/.local/bin/"
    curl -sL 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' | tar xz
    mv code "$HOME/.local/bin/"
    PATH="$HOME/.local/bin:$PATH"
else
    step "VS Code CLI already installed."
fi

# Enable linger for user.
if [[ ! $(loginctl show-user "$USER" -p Linger) == "Linger=yes" ]]; then
    step "Enabling linger for user..."
    sudo loginctl enable-linger "$USER"
else
    step "Linger already enabled for user."
fi

# Install VSCode Tunnel Service.
if ! systemctl is-enabled code-tunnel.service; then
    step "Installing VSCode Tunnel Service..."
    ~/.local/bin/code tunnel service install
else
    step "VSCode Tunnel Service already installed."
fi