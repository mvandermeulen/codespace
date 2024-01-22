#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e


CORE_APT_DEPS="coreutils bash ncurses-base sudo zip unzip zsh locales util-linux sqlite3 procps checkinstall bc software-properties-common"
BUILD_APT_DEPS="ninja-build gettext libevent-dev ncurses-dev build-essential make bison llvm libtool libtool-bin autoconf m4 automake gcc clang cmake g++ pkg-config git-all git-lfs binutils fontconfig"
STD_APT_DEPS="ca-certificates apt-transport-https lsb-release rename pdfgrep tree htop gnupg xz-utils gawk ncurses-term sed tar tig upx axel apt-file attr"
WEB_APT_DEPS="wget curl w3m w3m-img gpg gpg-agent"
LIB_APT_DEPS="libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libevent-core-2.1-7 libtinfo5"
USER_APT_DEPS="python-pip xclip less file diffutils jq inotify-tools fdupes file-roller bzip2 lzma gh entr exiftool pwgen ssh-askpass postgresql-client-common"
NVIM_APT_DEPS="shellcheck exuberant-ctags editorconfig sshfs"
RUBY_APT_DEPS="patch libyaml-dev libreadline6-dev libgmp-dev libncurses5-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev"
# Removed rustc from RUBY_APT_DEPS
NET_APT_DEPS="stunnel4 openssh-server openssh-client netcat socat mtr dnsutils net-tools tcpflow tcpdump inetutils-ping inetutils-traceroute nmap whois"
FILE_UTILITIES="lsof ncdu "

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
apt-install $NVIM_APT_DEPS
apt-install $RUBY_APT_DEPS
apt-install $NET_APT_DEPS

# Fuse
add-apt-repository universe -y && apt-get update
apt-install libfuse2 -y

# Cleanup
apt-get autoremove -y && apt-get clean -y
rm -rf /var/lib/apt/lists/*

# Exit
exit 0 