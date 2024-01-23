#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

add_ppa() {
  ppa="$1"
  if ! grep -q "^deb .*/$ppa/.*" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "adding apt source: $ppa"
    sudo add-apt-repository -y "ppa:$ppa" > /dev/null
fi
}

# only update the apt index once
apt_updated=""

install_package() {
  package="$1"
  force="$2"
  if [ -z "$(dpkg -l "$package" 2>/dev/null)" ] || [ -n "$force" ]; then
    if [ -z "$apt_updated" ]; then
      echo "updating apt index"
      sudo apt-get -qqy update > /dev/null
      apt_updated="yes"
    fi
    echo "installing $package"
    sudo apt-get -qqy install "$package" > /dev/null
  fi
}

install_latest_package() {
  package="$1"
  status="$(apt-cache policy "$package")"
  installed="$(echo "$status" | grep "Installed:" | sed -e 's/\s*Installed:\s*1://g')"
  available="$(echo "$status" | grep "Candidate:" | sed -e 's/\s*Candidate:\s*1://g')"
  if [ "$installed" != "$available" ]; then
    echo "updating $package version, installed: $installed, available: $available"
    install_package "$package" force
  fi
}

# add repository containing recent git versions
add_ppa "git-core/ppa"
# add repository containing all python versions
add_ppa "deadsnakes/ppa"

# install required packages
install_latest_package git  # update git to latest version always
install_package "python${PYTHON_VERSION}"  # install specific python version
install_package "python${PYTHON_VERSION}-venv"  # python virtual environment
install_package python-is-python3  # force everyone on python3
install_package pipx  # to use standalone pre-commit
install_package xorg  # required for GUI
install_package openbox  # required for GUI
install_package libfuse2  # required for PyCharm

exit 0
