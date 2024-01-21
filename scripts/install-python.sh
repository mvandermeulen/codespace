#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
PYTHON_VERSION_MAJOR=${PYTHON_VERSION_MAJOR:-"3.12"}
PYTHON_VERSION=${PYTHON_VERSION:-"$PYTHON_VERSION_MAJOR.0"}


sudo git clone https://github.com/pyenv/pyenv.git /opt/.pyenv \
    && /opt/.pyenv/bin/pyenv install $PYTHON_VERSION \
    && sudo update-alternatives --install /usr/bin/python3 python3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/python3 100 --force \
    && sudo update-alternatives --install /usr/bin/pip3 pip3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/pip3 100 --force \
    && sudo ln -s /usr/share/pyshared/lsb_release.py $HOME/.pyenv/versions/$PYTHON_VERSION/lib/python$PYTHON_VERSION_MAJOR/site-packages/lsb_release.py

# Install pyenv
# https://github.com/pyenv/pyenv-installer

curl https://pyenv.run | bash

# Pyenv requirements
sudo dnf install -y \
    make gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel

pyenv install 3.12.1

# Create neovim environment
pyenv virtualenv --system-site-packages --force system neovim
PYENV_ROOT=~/.pyenv
PATH="$PYENV_ROOT/versions/neovim/bin:$PATH" pip install --upgrade pip pynvim pydbus sphinx


exit 0