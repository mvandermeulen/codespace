#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}
PYTHON_VERSION_MAJOR=${PYTHON_VERSION_MAJOR:-"3.12"}
PYTHON_VERSION=${PYTHON_VERSION:-"$PYTHON_VERSION_MAJOR.1"}

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
source ~/.bashrc

sudo git clone https://github.com/pyenv/pyenv.git /opt/.pyenv \
    && /opt/.pyenv/bin/pyenv install $PYTHON_VERSION \
    && sudo update-alternatives --install /usr/bin/python3 python3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/python3 100 --force \
    && sudo update-alternatives --install /usr/bin/pip3 pip3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/pip3 100 --force \
    && sudo ln -s /usr/share/pyshared/lsb_release.py $HOME/.pyenv/versions/$PYTHON_VERSION/lib/python$PYTHON_VERSION_MAJOR/site-packages/lsb_release.py

# Install pyenv
# https://github.com/pyenv/pyenv-installer
# curl https://pyenv.run | bash

pyenv install $PYTHON_VERSION

# Create neovim environment
pyenv virtualenv --system-site-packages --force system neovim
PYENV_ROOT=$HOME/.pyenv
PATH="$PYENV_ROOT/versions/neovim/bin:$PATH" pip install --upgrade pip pynvim pydbus sphinx cython virtualenv

pip install -U pip

exit 0