#!/usr/bin/env bash

set -eux -o pipefail

# It's used for the compare and swap tests to verify our compare & swap
# implementation
apt-get install -y redis-server
