FROM ubuntu:latest
LABEL maintainer="mvandermeulen"

# errexit
RUN set -e

ENV TZ=Australia/Sydney
ARG USERNAME=dev
ENV USERNAME $USERNAME
ARG USER_UID=1000
ENV USER_UID $USER_UID
ARG USER_GID=$USER_UID
ENV USER_GID $USER_GID
ARG DEBIAN_FRONTEND="noninteractive"
ENV DEBIAN_FRONTEND $DEBIAN_FRONTEND
ARG FONT_VERSION="3.0.1"
ENV FONT_VERSION $FONT_VERSION
ENV LC_ALL=C.UTF-8

COPY ./scripts/common/install-deps.sh .
COPY ./scripts/common/configure-timezone-locales.sh .
COPY ./scripts/common/setup-user.sh .

RUN ./install-deps.sh \
    && ./configure-timezone-locales.sh \
    && export LANG=en_AU.UTF-8 \
    && ./setup-user.sh

USER $USERNAME
# Set shell to zsh
SHELL ["zsh", "-c"]

# Setup paths
ENV HOME=/home/$USERNAME
ENV CODESPACE=codespace
ARG INSTALL_PATH=/home/$USERNAME/.installed
ENV INSTALL_PATH $INSTALL_PATH
# ENV GOPATH=$HOME/.go
ENV RUSER=root
ENV RHOME=/root
WORKDIR $HOME
COPY --chown=$USERNAME ./scripts /home/$USERNAME/scripts
COPY --chown=$USERNAME ./config /home/$USERNAME/config
RUN ./scripts/common/setup-directories.sh


#####################
# Setup ZSH
#####################
ENV ZSH=$HOME/.oh-my-zsh
ENV RZSH=$RHOME/.oh-my-zsh
ENV SHELL=/bin/zsh
RUN ./scripts/setup-zsh.sh
# Add HELP
COPY --chown=$USERNAME ./config/HELP /home/$USERNAME/HELP

#####################
# Setup FZF
#####################
RUN ./scripts/common/install-tmux.sh \
    && ./scripts/install-fzf.sh \
    && ./scripts/common/install-nvim.sh


##########################################
# Setup Python 3.12, Golang 1.21, Rust & NVM
##########################################
ARG PYTHON_VERSION_MAJOR=3.12
ENV PYTHON_VERSION_MAJOR $PYTHON_VERSION_MAJOR
ARG PYTHON_VERSION=$PYTHON_VERSION_MAJOR.0
ENV PYTHON_VERSION $PYTHON_VERSION
ARG TARGET=stable
ENV TARGET $TARGET

RUN ./scripts/install-python.sh \
    && ./scripts/install-node.sh \
    && ./scripts/install-rust.sh \
    && ./scripts/install-golang.sh \
    && ./scripts/install-ruby.sh

ENV GO111MODULE="on"
ENV PYENV_ROOT="/opt/.pyenv"
ENV PATH="$PATH:/home/$USERNAME/.cargo/bin:$PYENV_ROOT/bin:/home/$USERNAME/.go/bin"
### Update python path for global (use # for sed delimiter)
ENV PYTHON_PATH=/home/$USERNAME/.pyenv/versions/$PYTHON_VERSION/bin/python3
ENV PATH "/home/dev/.cargo/bin:/home/dev/.rustup/toolchains/stable-x86_64-unknown-linux-musl/bin:$PATH"

RUN ./scripts/install-rust-packages.sh \
    && ./scripts/install-golang-packages.sh \
    && ./scripts/install-python-packages.sh \
    && ./scripts/install-node-packages.sh


#####################
# Setup kubectl, natscli, 
#####################
RUN ./scripts/install-kubectl.sh \
    && ./scripts/install-nats-cli.sh \
    && ./install-aws-cli.sh

#####################
# Install language servers
#####################
RUN ./scripts/install-language-servers.sh

#####################
# Setup Lua
#####################
RUN ./scripts/setup-lua.sh

#####################
# Setup Neovim
#####################
RUN ./scripts/install-nvim.sh

#####################
# Setup Tmux
#####################



#####################
# Cleanup
#####################
# RUN rm -rf .dotfiles
RUN ./scripts/cleanup.sh
# Set the active user
USER $USERNAME
ENV OS_NAME=ubuntu
# Set default entrypoint and command
ENTRYPOINT ["zsh", "-c"]
CMD ["/bin/zsh"]