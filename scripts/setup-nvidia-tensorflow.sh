#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

### NVIDIA settings for GPU-accelerated Tesorflow applications in docker containers ###
# NOTE: https://www.tensorflow.org/install/docker
if [[ -n $(lspci | grep -io 'nvidia') ]]; then
  # NVIDIA Container Toolkit
  # NOTE: https://github.com/NVIDIA/nvidia-container-toolkit
  # NOTE: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
      sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
      sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
    && \
      sudo apt-get update
  apt-get install -y nvidia-container-toolkit
  
  # configure docker
  nvidia-ctk runtime configure --runtime=docker
  systemctl restart docker # restart docker deamon
  # configure containerd
  # NOTE: Docker Engine uses containerd for managing the container lifecycle (see https://docs.docker.com/engine/alternative-runtimes/#what-runtimes-can-i-use)
  nvidia-ctk runtime configure --runtime=containerd
  systemctl restart containerd # restart containerd deamon
  # NOTE: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/sample-workload.html
  # sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi # sample workload
  # NOTE: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#nvidia-open-gpu-kernel-modules
fi

exit 0