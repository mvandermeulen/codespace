#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

# Install gpu drivers ----------------------------
# ubuntu-drivers devices
# sudo apt install nvidia-driver-535

# Install cuda 12.2.0 ----------------------------
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda-repo-ubuntu2204-12-2-local_12.2.0-535.54.03-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-2-local_12.2.0-535.54.03-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-2-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda


# Source https://gist.github.com/danielduckworth/f379b61ef1d1ac26852e444667c92f3c
wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda_12.0.0_525.60.13_linux.run
bash cuda_12.0.0_525.60.13_linux.run --no-drm --no-man-page --override --toolkitpath=~/local/cuda-12.0/ --toolkit --silent
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:~/local/cuda-12.0/lib64" >> ~/.bashrc
echo "export PATH=\$PATH:~/local/cuda-12.0/bin" >> ~/.bashrc
source ~/.bashrc


exit 0