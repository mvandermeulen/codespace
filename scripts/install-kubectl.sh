#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
LOCAL_BIN=${LOCAL_BIN:-"$HOME/.local/bin"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

bash -c 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"' \
    && chmod +x $HOME/kubectl && mv $HOME/kubectl "${LOCAL_BIN}/kubectl"

# kubectl tool used to run commands against Kubernetes cluster 
sudo bash -c "curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg"
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo bash -c "tee /etc/apt/sources.list.d/kubernetes.list"
sudo bash -c "apt update && apt install kubectl -y"

# Install Helm to use to manage your K8 deployments
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo bash -c "apt update && apt install helm"

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add janpreet https://janpreet.github.io/helm-charts/
helm repo update

# Use Flux to keep k8 clusters in sync when config changes or when there is new code to deploy.
# curl -s https://fluxcd.io/install.sh | sudo bash

# Argo CD (my preference instead of Flux)
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argo-cd argo/argo-cd


function install_kubectl () {
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install kubectl -y
}

exit 0