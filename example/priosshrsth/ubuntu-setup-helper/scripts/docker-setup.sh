#!/bin/env bash

temp=$( realpath "$0"  )
CURRENT_DIR=$(dirname "$temp")

echo "setting up docker"

sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

sudo docker network create --gateway 172.18.0.1 --subnet 172.18.0.0/24 pagevamp


## Setup docker compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "$(docker-compose -v)"

## Adding name servers to fix docker connection issue

sudo tee -a /etc/resolv.conf > /dev/null <<EOT

nameserver 8.8.8.8
nameserver 8.8.4.4

EOT
