#!/bin/env bash

git clone git@github.com:priosshrsth/docker-dev.git ~/docker-dev

cd ~/docker-dev

docker compose up -d

## Adding hosts entries
# Configure mysql
sudo tee -a /etc/hosts > /dev/null <<EOT

#[Custom Entries]
172.18.0.13 mysql
172.18.0.15 mysql7
172.18.0.14 mysql8
172.18.0.16 postgres
172.18.0.17 mongo
172.18.0.18 redis
172.18.0.19 pgram

127.0.0.2 phpmyadmin.local
127.0.0.2 redis.local
127.0.0.2 omnidb.local
127.0.0.2 pgadmin.local
127.0.0.2 mailhog.local
127.0.0.2 mailhog.dev

EOT