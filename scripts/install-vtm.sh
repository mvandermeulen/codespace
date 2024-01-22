#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

cd ${XDG_RUNTIME_DIR} \
&& wget -qO- https://github.com/netxs-group/vtm/releases/download/v0.9.9t/vtm_linux_x86_64.tar.gz \
| tar xz vtm_linux_x86_64 \
&& cd vtm_linux_x86_64 \
&& chmod +x vtm \
&& ./vtm \
&& rm -rf ../vtm_linux_x86_64

exit 0