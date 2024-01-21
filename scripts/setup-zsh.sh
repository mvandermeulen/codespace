#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
RHOME=${RHOME:-"/root"}
ZSH=${ZSH:-"$HOME/.oh-my-zsh"}
RZSH=${RZSH:-"$RHOME/.oh-my-zsh"}
SHELL=${SHELL:-"/bin/zsh"}


# Install ohmyzsh
# https://github.com/ohmyzsh/ohmyzsh

curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh /dev/stdin --unattended

# Plugins
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions


# Install and configure oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp -r $ZSH $RZSH
\cp -f $HOME/.dotfiles/zsh/.zshrc $HOME/
\cp -f $HOME/.dotfiles/zsh/.zshrc $RHOME/
cp $HOME/.dotfiles/zsh/codespace*.zsh-theme $ZSH/themes/
cp $HOME/.dotfiles/zsh/codespace*.zsh-theme $RZSH/themes/
git clone https://github.com/jocelynmallon/zshmarks $ZSH/custom/plugins/zshmarks
cp -r $ZSH/custom/plugins/zshmarks $RZSH/custom/plugins/zshmarks



# Install and configure oh-my-zsh
RUN zsh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && cp -r $ZSH $RZSH && cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc \
    && cp $HOME/.zshrc $RHOME/ \
    && cp .dotfiles/zsh/codespace*.zsh-theme $ZSH/themes/ \
    && cp .dotfiles/zsh/codespace*.zsh-theme $RZSH/themes/ \
    && git clone https://github.com/jocelynmallon/zshmarks $ZSH/custom/plugins/zshmarks \
    && cp -r $ZSH/custom/plugins/zshmarks $RZSH/custom/plugins/zshmarks \
    && zsh -c "source ~/.zshrc"
    # && sh -c "sudo usermod -s /bin/zsh root"



# Add command alias
echo "alias gittree='git log --oneline --graph --all'" >> ~/.zshrc \
  && echo "alias ptpython='python3 -m ptpython'" >> ~/.zshrc

