WSL development setup
=====================

A list of scripts I use to get myself set up quickly in a WSL Ubuntu machine.
The scripts are designed to be runnable multiple times if needed, and only apply
missing changes and updates.

## How to run

Download this repo as a zip file, unzip it and run `./setup-nix-user.sh`.
Example:

```console
sudo apt-get install unzip  # ensure you have unzip installed
wget \
  https://github.com/ilCatania/dev-setup-wsl/archive/refs/heads/master.zip \
  -O setup.zip &&
unzip setup.zip &&
dev-setup-wsl-master/setup-nix-user.sh
```
## Setup steps

The following set up steps will be performed automatically by the script:

- install required packages on WSL Ubuntu (latest `git`, python version 3.10,
  all the packages required for the graphical desktop environment, `pipx`, etc)
- `git` client global configuration
- `ssh` and `gpg` key creation
- register `ssh` and `gpg` keys with [github](https://github.com) via prompt
- set up python development tools (`pre-commit`, `cookiecutter`, etc)
- install JetBrains Toolbox and run it, prompt the user to install PyCharm
