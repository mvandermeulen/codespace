#!/bin/bash

set -e

BTOPVERS="1.2.13"
BTOPURL="https://github.com/aristocratos/btop/releases/download/v${BTOPVERS}/btop-x86_64-linux-musl.tbz"

wget ${BTOPURL}
tar xvf btop-x86_64-linux-musl.tbz
cd btop
sed -e 's/^BANNER/#BANNER/' -i Makefile
./install.sh PREFIX=/usr
./setuid.sh PREFIX=/usr
cd ../
rm -rf btop btop-x86_64-linux-musl.tbz