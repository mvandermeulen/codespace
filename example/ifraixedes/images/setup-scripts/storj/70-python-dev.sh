#!/usr/bin/env bash

set -eux -o pipefail

# Install the opinionated black code auto-formatter.
apt-get install -y python3 python3-pip black
