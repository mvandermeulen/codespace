#!/bin/bash

info() {
	echo -n "install nodejs and its dependencies"
}

run() {
    require_pacman nodejs npm
    msg "$(node -v)"
}
