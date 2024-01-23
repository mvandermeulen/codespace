#!/bin/bash

info() {
	echo -n "install python and its dependencies"
}

run() {
    require_pacman python python-pip

	# sudo dnf install python3 -y
	# python -m pip install --upgrade pip # install pip package manager
	# pip install --upgrade autopep8
    
    msg "update user-local version of pip"
	python -mpip install --user --pre -U pip

    local packages=(flake8 pep8-naming pipenv poetry hatch pdm black)
    for package in "${packages[@]}"; do
		if python -mpip install --user --pre -U "$package"; then
			msg "$package installation succeeded"
		else
			msg "$package installation failed"
		fi
	done
}
