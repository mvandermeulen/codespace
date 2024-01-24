#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}

PYTHON_PACKAGES="setuptools gitgud ptpython vmux pylint flake8 black python-lsp-server[all] python-language-server grpcio-tools cython cookiecutter pgzero lizard ruff"
PYTHON_ROOT_PACKAGES="pip ranger-fm thefuck httpie jedi virtualenv ptpython neovim pipenv poetry mypy notebook"
# tldr

PYTHON_DATA_SCIENCE_PACKAGES="scikit-learn matplotlib hydra perfect"

PYTORCH_PACKAGES="torch torchvision torchaudio"
PYTHON_CLIENTS="pgcli iredis"

pip-root-install() {
	sudo python3 -m pip install --upgrade "$@"
}

pip-install() {
	python3 -m pip install --upgrade "$@"
	if [ $? -gt 0 ]; then
        python3 -m pip install -U --upgrade "$@"
    fi
}

python3 -m pip install --upgrade pip

for item in $PYTHON_PACKAGES; do
	pip-install "$item"
done

for item in $PYTHON_ROOT_PACKAGES; do
	pip-root-install "$item"
done

exit 0