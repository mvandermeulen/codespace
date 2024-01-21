#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e


CORE_APT_DEPS="coreutils bash ncurses-base sudo zip unzip zsh locales util-linux sqlite3 procps checkinstall bc"
BUILD_APT_DEPS="ninja-build gettext libevent-dev ncurses-dev build-essential make bison llvm libtool libtool-bin autoconf automake gcc cmake g++ pkg-config git binutils fontconfig"
STD_APT_DEPS="ca-certificates apt-transport-https lsb-release vim fd-find rename ripgrep tree htop gnupg xz-utils gawk ncurses-term sed tar tig upx axel"
WEB_APT_DEPS="wget curl w3m w3m-img netcat socat mtr openssh-client"
LIB_APT_DEPS="libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libevent-core-2.1-7 libtinfo5"
USER_APT_DEPS="python-pip xclip dnsutils net-tools tcpflow tcpdump less inetutils-ping inetutils-traceroute file diffutils jq"

apt-install() {
	apt-get install --no-install-recommends -y "$@"
}

# Install packages
echo "Installing dependencies..."
apt-get update
apt-install $CORE_APT_DEPS
apt-install $STD_APT_DEPS
apt-install $USER_APT_DEPS
apt-install $WEB_APT_DEPS
apt-install $BUILD_APT_DEPS
apt-install $LIB_APT_DEPS

# Cleanup
apt-get autoremove -y && apt-get clean -y
rm -rf /var/lib/apt/lists/*

# Exit
exit 0 