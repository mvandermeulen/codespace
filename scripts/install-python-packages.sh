#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

PYTHON_PACKAGES="setuptools gitgud ptpython vmux pylint flake8 black python-lsp-server[all] python-language-server grpcio-tools"
PYTHON_ROOT_PACKAGES="pip ranger-fm thefuck httpie jedi virtualenv ptpython neovim pipenv poetry mypy"
# tldr


pip-root-install() {
	sudo python3 -m pip install --upgrade "$@"
}

pip-install() {
	python3 -m pip install --upgrade "$@"
}

python3 -m pip install --upgrade pip

for item in $PYTHON_PACKAGES; do
	pip-install "$item"
done

for item in $PYTHON_ROOT_PACKAGES; do
	pip-root-install "$item"
done

exit 0