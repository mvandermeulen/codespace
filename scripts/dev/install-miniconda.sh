#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

mkdir -p $HOME/.miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/.miniconda3/miniconda.sh
bash  $HOME/.miniconda3/miniconda.sh -b -u -p $HOME/.miniconda3/
rm -rf $HOME/.miniconda3/miniconda.sh
~/.miniconda3/bin/conda init bash

## conda
conda config --remove channels defaults
conda config --append channels conda-forge
conda update -y python -c conda-forge --override-channels
conda update -y -c conda-forge --override-channels --all
## ソルバを高速なmambaに変更
conda update -y -n base conda
conda install -y -n base conda-libmamba-solver
conda config --set solver libmamba
if [[ $INIT_OSNAME == "wsl" ]] || [[ $INIT_OSNAME == "linux" ]]; then
  ## VSCode Tunnelの設定
  code tunnel service install --accept-server-license-terms
  systemctl --user daemon-reload
  systemctl --user start code-tunnel
  systemctl --user enable code-tunnel
  systemctl --user restart code-tunnel
fi


exit 0