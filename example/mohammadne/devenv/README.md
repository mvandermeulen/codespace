# Devenv

Provisioner for setup a tailored environment for development

> This repository is itegrated with my [dotfiles repository](https://github.com/mohammadne/dotfiles) to setup the environment.

## Usage

![Fedora Compatibility](https://img.shields.io/badge/works%20on-fedora-white?logo=fedora&style=for-the-badge)
![Ubuntu Compatibility](https://img.shields.io/badge/works%20on-ubuntu-white?logo=ubuntu&style=for-the-badge)

> **_NOTE:_** I'm using Fedora as my desktop OS and Ubuntu as my development server choice and this provisioner repository (devenv) is written and tested based on them.

```sh
# specify your preferred location for cloning after '--' at the end of the script below
bash -c "$(curl -fsSL https://raw.githubusercontent.com/mohammadne/devenv/main/scripts/clone.sh)"

# change to your devenv directory and install required packages
cd $HOME/Documents/workspace/devenv && ./scripts/install.sh git ssh
```

## run

```sh
eval "$(ssh-agent)"
ssh-add ~/.ssh/github_ed25519

docker compose run devenv
```
