#!/bin/bash

set -e

apt-get update

apt-get install -y --no-install-recommends \
build-essential \
gdb \
python3-pip \
tmux

python3 -m pip install \
aioredis \
alpaca-py \
frogmouth \
gdbfrontend \
matplotlib \
pandas \
pandas_ta \
pudb \
pyfinance \
pygments \
pyzmq \
redis[hiredis] \
xxhash

apt-get clean

rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*