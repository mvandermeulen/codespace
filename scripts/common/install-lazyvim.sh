export PATH="/workspace/.neovim/bin:$PATH"

USER_DIR="$(eval echo '~')"
NVIM_DIR=/workspace/.nvim/config
NVIM_PLUGINS_DIR="$NVIM_DIR/lua/plugins/"
USER_NVIM_DIR="$USER_DIR/.config/nvim"
DOTFILES_DIR="/workspace/dotfiles"
DOTFILES_PLUGINS_DIR="$DOTFILES_DIR/lazyvim/plugins"

function addCustomPlugins() {
  echo "[saimon's dotfiles] Installing custom plugins for LazyVim..."
  echo

  cp -fr $DOTFILES_PLUGINS_DIR/* $NVIM_PLUGINS_DIR
}

echo "[saimon's dotfiles] Installing linux deps..."
apt install -qq -y build-essential libssl-dev pkg-config unzip ripgrep fd-find jq fzf > /dev/null

echo "[saimon's dotfiles] Checking neovim!"
if ! command -v nvim &> /dev/null
then
    echo "[saimon's dotfiles] Installing neovim!"

    mkdir -p /workspace/.neovim/bin

    pushd /tmp
    wget -q https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-linux64.tar.gz
    tar xfz nvim-linux64.tar.gz > /dev/null

    mv ./nvim-linux64/* /workspace/.neovim/
    popd
fi

echo "[saimon's dotfiles] Checking LazyVim!"
if [[ ! -d $USER_NVIM_DIR ]]
then
    echo "[saimon's dotfiles] Installing LazyVim..."
    mkdir -p $NVIM_DIR

    git clone https://github.com/LazyVim/starter.git $NVIM_DIR --depth 1  > /dev/null
    ln -nfs $NVIM_DIR $USER_NVIM_DIR
    echo "[saimon's dotfiles] Installed LazyVim!"
    echo

    addCustomPlugins
fi