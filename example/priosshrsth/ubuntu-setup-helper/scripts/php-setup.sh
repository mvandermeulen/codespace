#!/bin/env bash

temp=$( realpath "$0"  )
CURRENT_DIR=$(dirname "$temp")

mkdir -p ~/public_html
cp ${CURRENT_DIR}/../info.php ~/public_html/info.php

sudo apt install php php-fpm php-cli php-mysql php-zip php-xml \
     php-mbstring php-curl php-intl php-mongodb php-bcmath php-gd \
     php-sqlite3

sudo cp ${CURRENT_DIR}/../nginx/nginx.conf /etc/nginx/nginx.conf

sudo cp ${CURRENT_DIR}/../nginx/default /etc/nginx/sites-enabled/default

sudo nginx -s reload
