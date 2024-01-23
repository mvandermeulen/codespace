#!/usr/bin/env bash

set -eux -o pipefail

# Arduino AVR
apt-get install -y \
  gcc-avr \
  arduino-core-avr \
  avrdude

# Rust AVR HAL requirement (https://github.com/Rahix/avr-hal)
apt-get install -y libudev-dev
