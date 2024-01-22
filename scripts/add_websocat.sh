#!/bin/bash

set -e

WEBSOCATVERS="1.12.0"
WEBSOCATURL="https://github.com/vi/websocat/releases/download/v${WEBSOCATVERS}/websocat.x86_64-unknown-linux-musl"

wget ${WEBSOCATURL} -O /usr/bin/websocat
chmod 0755 /usr/bin/websocat