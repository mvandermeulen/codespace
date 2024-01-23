#!/usr/bin/env zsh

set -e
cd ~

# Ubuntu

sudo apt update
sudo apt -y install vim

# Homebrew

yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Brew managed tools

tools=(
    fzf
    gh
    go
    hashicorp/tap/terraform
    helm
    infracost
    istioctl
    jq
    kubectl
    kubectx
    k9s
    opa
    pre-commit
    romkatv/powerlevel10k/powerlevel10k
    ruby
    terraform-docs
    zsh-syntax-highlighting
)

brew install "${tools[@]}"

# Automatically enable pre-commit on repositories

git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template

# Zsh

command -v zsh | sudo tee -a /etc/shells

# Ruby

export RUBYOPT="-W:no-deprecated -W:no-experimental"

echo 'gem: --no-document' > ~/.gemrc

cat << EOF > ~/.rubocop.yml
Style/FrozenStringLiteralComment:
          Enabled: false
EOF

# Pathogen.vim

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Pathogen plugins

git clone https://github.com/hashivim/vim-terraform ~/.vim/bundle/vim-terraform

cat << EOF > ~/.vimrc
set visualbell

execute pathogen#infect()

filetype plugin indent on
syntax on

let g:terraform_fmt_on_save=1
let g:terraform_align=1
EOF

# GitHub extensions

# For some reason we need to authenticate to GitHub to install extensions

# gh extension install github/gh-copilot github/gh-projects actions/gh-actions-cache advanced-security/gh-sbom

# Google Cloud SDK

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
| sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt -y install google-cloud-sdk

# Oh My Zsh

if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Shell setup

if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc-`date +"%Y%m%d_%H%M%S"`.bak
fi

# Comment out default plugins

sed -i '/^plugins=(git)$/s/^/#/' ~/.zshrc

cat << 'EOF' >> ~/.zshrc
alias gpg-passphrase="echo "test" | gpg --clearsign > /dev/null 2>&1"

export GOOGLE_AUTH_SUPPRESS_CREDENTIALS_WARNINGS=true
export GPG_TTY=$TTY
export EDITOR=vim
export RUBYOPT="-W:no-deprecated -W:no-experimental"

zstyle ':completion::complete:*' use-cache 1

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.exports ]] || source ~/.exports

source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/linuxbrew/.linuxbrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
EOF

echo -e "plugins=(git terraform gcloud bundler docker kubectl gem helm kitchen zsh-autosuggestions)\n$(cat ~/.zshrc)" > ~/.zshrc
echo -e "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"\n$(cat ~/.zshrc)" > ~/.zshrc
echo -e "export PATH=\$HOME/bin:/home/linuxbrew/.linuxbrew/lib/ruby/gems/3.3.0/bin:\$PATH\n$(cat ~/.zshrc)" > ~/.zshrc

# Create update script

mkdir -p ~/bin
cat << 'EOF' > ~/bin/update.sh
#!/usr/bin/env zsh

source ~/.zshrc

# Oh-my-zsh
${ZSH}/tools/upgrade.sh

# Ubuntu
sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove

# Brew
brew update
brew upgrade
brew autoremove
brew cleanup

# Pathogen Plugins
cd ~/.vim/bundle/vim-terraform
git pull

# zsh-autocomplete
cd ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git pull

EOF

chmod 755 ~/bin/update.sh
