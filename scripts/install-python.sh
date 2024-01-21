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

exit 0