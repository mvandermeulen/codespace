#!/bin/env bash

temp=$( realpath "$0"  )
CURRENT_DIR=$(dirname "$temp")

## Add yarn repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

## Updating repos
sudo apt update

## Installing basic packages
sudo apt install --no-install-recommends yarn
sudo apt install -y zsh vlc gimp gnome-tweak-tool gpart curl \
      git-core zlib1g-dev build-essential libssl-dev libreadline-dev \
      libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
      libcurl4-openssl-dev software-properties-common libffi-dev \
      fonts-powerline mysql-client libmysqlclient-dev zsh nginx \
      fonts-font-awesome python3-venv python3-pip

# Install exa For ubuntu 20.10
sudo apt install -y exa

chsh -s $(which zsh)

## Install fonts
${CURRENT_DIR}/font-installer.sh

# Configure mysql
sudo tee -a /etc/mysql/my.cnf > /dev/null <<EOT
[client]
host=mysql7
user=root
password=root

EOT

sudo gpasswd -a www-data $USER
# sudo nginx -s reload
