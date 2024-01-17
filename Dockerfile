FROM ubuntu:latest
LABEL maintainer="mvandermeulen"

# errexit
RUN set -e

# Set timezone
ENV TZ=Australia/Sydney
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG USERNAME=dev
ENV USERNAME $USERNAME

ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBIAN_FRONTEND="noninteractive"
ARG BUILD_APT_DEPS="ninja-build gettext libevent-dev ncurses-dev build-essential make bison llvm libtool libtool-bin autoconf automake gcc cmake g++ pkg-config git binutils fontconfig"
ARG STD_APT_DEPS="ca-certificates apt-transport-https lsb-release vim zip unzip sudo zsh locales fd-find rename ripgrep tree htop gnupg xz-utils"
ARG WEB_APT_DEPS="wget curl w3m w3m-img netcat socat"
ARG LIB_APT_DEPS="libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libevent-core-2.1-7"
ARG USER_APT_DEPS="python-pip xclip dnsutils net-tools tcpflow tcpdump less inetutils-ping inetutils-traceroute file"
ARG FONT_VERSION="3.0.1"

# diffutils gawk jq libtinfo5 mtr ncurses-term openssh-client sed tar tig upx axel



# Install Dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends ${STD_APT_DEPS} \
    && apt-get install -y --no-install-recommends ${WEB_APT_DEPS} \
    && apt-get install -y --no-install-recommends ${USER_APT_DEPS} \
    && apt-get install -y --no-install-recommends ${BUILD_APT_DEPS} \
    && apt-get install -y --no-install-recommends ${LIB_APT_DEPS} \
    && apt-get autoremove -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Configure Locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_AU.UTF-8
RUN export LANG=en_AU.UTF-8 

#
# Add work user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

# Set shell to zsh
SHELL ["zsh", "-c"]

#
# Setup paths
ENV HOME=/home/$USERNAME
ENV CODESPACE=codespace
# ENV GOPATH=$HOME/.go
ENV RUSER=root
ENV RHOME=/root
ENV LC_ALL=C.UTF-8
WORKDIR $HOME

ARG INSTALL_PATH=/home/$USERNAME/installed
ENV INSTALL_PATH $INSTALL_PATH
RUN mkdir -p $INSTALL_PATH && mkdir -p $HOME/$CODESPACE \
    && mkdir -p $HOME/.local/{src,bin,share,docs,include,tmp,log,lib,cache,history} \
    && mkdir -p $HOME/.config/nvim \
    && mkdir -p $HOME/.tmux/{scripts,themes,plugins} \
    && mkdir -p $HOME/.tmuxp


#####################
# Setup ZSH
#####################
ENV ZSH=$HOME/.oh-my-zsh
ENV RZSH=$RHOME/.oh-my-zsh
ENV SHELL=/bin/zsh

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

#####################
# Setup FZF
#####################

RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf \
    && cp -r $HOME/.fzf $RHOME/.fzf \
    && $HOME/.fzf/install --all || true \
    && rm -f $HOME/.bashrc $HOME/.fzf/code.bash
    # && rm -f $RHOME/.bashrc $RHOME/.fzf.bash




#####################
# Setup 
#####################









#####################
# Setup NVM
#####################



##########################################
# Setup Python 3.12, Golang 1.21, Rust & NVM
##########################################
ARG PYTHON_VERSION_MAJOR=3.12
ARG PYTHON_VERSION=$PYTHON_VERSION_MAJOR.0

RUN wget -O $INSTALL_PATH/go1.21.linux-amd64.tar.gz https://go.dev/dl/go1.21.5.linux-amd64.tar.gz \
    && sudo mkdir -p /usr/go \
    && sudo tar -C /usr/go -xvf $INSTALL_PATH/go1.21.linux-amd64.tar.gz \
    && sudo update-alternatives --install /usr/bin/go go /usr/go/go/bin/go 100 --force \
    && sudo update-alternatives --install /usr/bin/gofmt gofmt /usr/go/go/bin/gofmt 100 --force \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm ' >> $HOME/.zshrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> $HOME/.zshrc \
    && source $HOME/.nvm/nvm.sh && nvm install node && nvm install --lts && nvm use --lts \
    && sudo git clone https://github.com/pyenv/pyenv.git /opt/.pyenv \
    && /opt/.pyenv/bin/pyenv install $PYTHON_VERSION \
    && sudo update-alternatives --install /usr/bin/python3 python3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/python3 100 --force \
    && sudo update-alternatives --install /usr/bin/pip3 pip3 $HOME/.pyenv/versions/$PYTHON_VERSION/bin/pip3 100 --force \
    && sudo ln -s /usr/share/pyshared/lsb_release.py $HOME/.pyenv/versions/$PYTHON_VERSION/lib/python$PYTHON_VERSION_MAJOR/site-packages/lsb_release.py


ENV PATH "/home/lspcontainers/.cargo/bin:/home/lspcontainers/.rustup/toolchains/stable-x86_64-unknown-linux-musl/bin:$PATH"

RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/sh.rustup.rs \
    && chmod +x /tmp/sh.rustup.rs \
    && /tmp/sh.rustup.rs --default-toolchain none -y \
    && rm -rf /tmp/sh.rustup.rs \
    && . "$HOME"/.cargo/env \
    && rustup toolchain install stable \
    && rustup component add rust-analyzer \
    rust-src
# Install cargo file watcher
cargo install cargo-watch
# required for goto source to work with the standard library
rustup component add rust-src --toolchain "$toolchain"


ENV GO111MODULE="on"
ENV PYENV_ROOT="/opt/.pyenv"
ENV PATH="$PATH:/home/$USERNAME/.cargo/bin:$PYENV_ROOT/bin:/home/$USERNAME/go/bin"
### Update python path for global (use # for sed delimiter)
ENV PYTHON_PATH=/home/$USERNAME/.pyenv/versions/$PYTHON_VERSION/bin/python3

# Add jless (json cli viewer), zellij, ptpython (python console)
RUN cargo install jless && cargo install ouch && cargo install zellij \
    && go install golang.org/x/tools/gopls@latest \
    && go install mvdan.cc/gofumpt@latest \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install setuptools \
    && python3 -m pip install tldr \
    && python3 -m pip install gitgud \
    && python3 -m pip install  \
    && python3 -m pip install  \
    && python3 -m pip install ptpython \
    && python3 -m pip install httpie \
    && python3 -m pip install vmux \
    && python3 -m pip install pylint && python3 -m pip install flake8 \
    && python3 -m pip install black && python3 -m pip install pylint && python3 -m pip install flake8 \
    && python3 -m pip install "python-lsp-server[all]" \
    && nvm exec npm install -g npm yarn pnpm \
    && nvm exec npm install -g eslint prettier \
    && nvm exec npm install -g typescript-language-server typescript \
    && nvm exec npm install -g svelte-language-server \
    && nvm exec npm install -g bash-language-server \
    && nvm exec npm install -g dockerfile-language-server-nodejs \
    && nvm exec npm install -g vscode-html-languageserver-bin \
    && nvm exec npm install -g pyright \
    && nvm exec npm install -g yaml-language-server \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \
    && nvm exec npm install -g  \

sudo python3 -m pip install jedi virtualenv ptpython neovim pipenv poetry mypy
pip3 install --upgrade pip ranger-fm thefuck httpie python-language-server vim-vint grpcio-tools

RUN go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest \
    && go install github.com/ramya-rao-a/go-outline@latest \
    && go install github.com/cweill/gotests/gotests@latest \
    && go install github.com/fatih/gomodifytags@latest \
    && go install github.com/josharian/impl@latest \
    && go install github.com/haya14busa/goplay/cmd/goplay@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install golang.org/x/tools/gopls@latest
#####################
# Setup Rust
#####################


#####################
# Setup kubectl, natscli, 
#####################
RUN bash -c 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"' \
    && chmod +x $HOME/kubectl && sudo mv $HOME/kubectl /usr/bin/kubectl \
    && wget -O $INSTALL_PATH/natscli-0.0.28-amd64.deb https://github.com/nats-io/natscli/releases/download/v0.0.28/nats-0.0.28-amd64.deb \
    && sudo dpkg -i $INSTALL_PATH/natscli-0.0.28-amd64.deb

#
# Install 
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o $INSTALL_PATH/awscliv2.zip \
  && chmod 755 $INSTALL_PATH/awscliv2.zip \
  && unzip $INSTALL_PATH/awscliv2.zip -d $INSTALL_PATH/awscli \
  && sudo $INSTALL_PATH/awscli/aws/install

#####################
# Install language servers
#####################





#####################
# Setup Lua
#####################
RUN sudo apt-get update && sudo apt-get install -y luarocks && sudo apt-get install -y lua-yaml \
    && luarocks install dkjson --local \
    && luarocks install say --local \
    && luarocks install checks --local \
    && luarocks --server=http://rocks.moonscript.org install lyaml --local



#####################
# Setup Neovim
#####################
ARG TARGET=stable
RUN git clone https://github.com/neovim/neovim.git $INSTALL_PATH/neovim && \
    cd $INSTALL_PATH/neovim && git fetch --all --tags -f && git checkout ${TARGET} && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/ && \
    make install && \
    strip /usr/local/bin/nvim

RUN nvim --headless +PlugInstall +qall

#####################
# Setup Tmux
#####################

RUN wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz && \
  tar xvf tmux-3.3a.tar.gz && \
  cd ./tmux-3.3a && \
  ./configure && \
  make && make install
# Configure tmux
RUN cp .dotfiles/tmux/.tmux.conf $HOME/
RUN cp .dotfiles/tmux/.tmux.conf $RHOME/
RUN git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
RUN cp -r $HOME/.tmux $RHOME/.tmux
RUN tmux start-server \
    && tmux new-session -d \
    && sleep 1 \
    && $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh \
    && tmux kill-server
RUN mkdir -p $HOME/.tmux/scripts \
    && cp -r .dotfiles/tmux/scripts $HOME/.tmux/
RUN mkdir -p $RHOME/.tmux/scripts \
    && cp -r .dotfiles/tmux/scripts $RHOME/.tmux/


# Add command alias
RUN echo "alias gittree='git log --oneline --graph --all'" >> ~/.zshrc \
  && echo "alias ptpython='python3 -m ptpython'" >> ~/.zshrc
# Add HELP
COPY --chown=$USERNAME ./config/HELP /home/$USERNAME/HELP

#####################
# Cleanup
#####################
# RUN rm -rf .dotfiles

# Give user their stuff and set default shells
RUN chown -R $USERNAME $HOME && usermod -s /bin/zsh $USERNAME && usermod -s /bin/zsh $RUSER && source ~/.zshrc
# Set the active user
USER $USER
ENV OS_NAME=ubuntu

# Set default entrypoint and command
ENTRYPOINT ["zsh", "-c"]
CMD ["/bin/zsh"]