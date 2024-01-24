#!/usr/bin/env bash

set -eux -o pipefail

# Install general compilers and building tools
apt-get install -y g++ dh-autoreconf pkg-config

# Install code tools
## https://github.com/ggreer/the_silver_searcher
apt-get install -y silversearcher-ag
