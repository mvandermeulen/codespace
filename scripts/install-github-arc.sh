#!/usr/bin/env bash

# This script installs, configures and starts GitHub ARC.
# /bin/bash -c "$(curl -fsSL https://gist.githubusercontent.com/kevinderuijter/1e9e351766b269ac41a2ebc2c8ff29b1/raw/arc.sh)"

# https://github.com/actions/actions-runner-controller/blob/master/docs/quickstart.md

# Add the following alias to .zshrc.
## Custom alias for miniKube server.
#if [[ -x "$(command -v minikube)" ]]; then
#    alias kubectl='minikube kubectl --'
#fi

# Example RunnerDeployment manifest:
# apiVersion: actions.summerwind.dev/v1alpha1
# kind: RunnerDeployment
# metadata:
#   name: repo-name-runner
# spec:
#   replicas: 1
#   template:
#     spec:
#       repository: johndoe/repo-name

# Then run `kubectl apply -f runnerdeployment.yaml`

STEP=0
step() {
    STEP=$((STEP+1))
    echo -e "\e[32m[$STEP/3]\e[0m $1"
}

# Show error with given message and exit.
raise() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

# Make sure a GitHub token is provided.
GITHUB_TOKEN=""
if [[ $GITHUB_TOKEN == "" ]]; then
	raise "Please set a GitHub token in the script."
fi

# Make sure script is running on Linux.
if [[ $(uname -s) != "Linux" ]]; then
    raise "This script is only for Linux."
fi

# Install minikube.
if ! command -v minikube; then
	step "Installing minikube..."
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
	sudo dpkg -i minikube_latest_amd64.deb
	rm minikube_latest_amd64.deb
else
	step "Minikube already installed."
fi

# Install docker.
if ! command -v docker; then
	step "Installing docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	rm get-docker.sh
	sudo groupadd docker
	sudo usermod -aG docker "$USER"
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service
	raise "Logout for changes to take effect!"
else
	step "Docker already installed."
fi

# Start minikube.
if command -v minikube && command -v docker; then
	if ! minikube status; then
		step "Starting minikube..."
		minikube start --driver=docker
		minikube kubectl -- apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml
		minikube kubectl -- apply -f https://github.com/actions/actions-runner-controller/releases/download/v0.27.6/actions-runner-controller.yaml --server-side
		minikube kubectl -- create secret generic controller-manager -n actions-runner-system --from-literal=github_token="$GITHUB_TOKEN"
	else
		step "Minikube already started."
	fi
fi