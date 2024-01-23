#!/bin/bash

function info() {
    echo -n "configure system to use Iran timezone"
}

function run() {
    sudo dnf install -qy "systemd"
    timedatectl set-timezone "Asia/Tehran"
}
