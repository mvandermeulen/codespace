# Clone dotfiles from public repo
RUN git clone https://github.com/tw-studio/dotfiles .dotfiles

# Docker file for jordanp-env image.
# @author Jordan Pyott

FROM ubuntu:20.04 AS builder

LABEL maintainer="atidyshirt"

ARG BUILD_APT_DEPS="ninja-build gettext libevent-dev ncurses-dev build-essential bison libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils wget fontconfig"
ARG FONT_VERSION="3.0.1"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET=stable

RUN apt update && apt upgrade -y && \
  apt install -y ${BUILD_APT_DEPS} && \
  git clone https://github.com/neovim/neovim.git /tmp/neovim && \
  cd /tmp/neovim && \
  git fetch --all --tags -f && \
  git checkout ${TARGET} && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/ && \
  make install && \
  strip /usr/local/bin/nvim

RUN wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz && \
  tar xvf tmux-3.3a.tar.gz && \
  cd ./tmux-3.3a && \
  ./configure && \
  make && make install

RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/FiraCode.zip && \
  unzip FiraCode.zip -d /usr/share/fonts && \
  fc-cache -fv

FROM ubuntu:20.04

COPY --from=builder /usr/local /usr/local/
COPY --from=builder /usr/share/fonts /usr/share/fonts/

ENV TERM=xterm-256color
ENV NVIM_LSP_DOCKER=true

# Ensure we don't get asked for timezone data - provide via ipapi api
RUN ln -fs /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime
RUN export DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

ENV NODE_MAJOR=18
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

ARG ENVIRONMENT_TOOLS="wget git ripgrep zsh gcc libevent-core-2.1-7 nodejs python software-properties-common"

RUN apt update && apt upgrade -y && \
  apt install -y ${ENVIRONMENT_TOOLS}

RUN npm install --global yarn typescript

RUN mkdir -p /root/.config/nvim
COPY ./config/ /root/.config/
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

COPY ./home/ /root/
RUN chsh -s $(which zsh)

RUN nvim --headless "+Lazy! sync" +qa

RUN mkdir -p /home/workspace
WORKDIR /home/workspace

CMD ["/bin/zsh"]












# Setup vim.
# https://github.com/amix/vimrc
#
if ! test -d "$HOME/.vim_runtime"; then
	git clone --depth=1 https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
	sh ~/.vim_runtime/install_basic_vimrc.sh
fi

# Setup tmux.
# https://github.com/gpakosz/.tmux
#
if ! test -d "$HOME/.tmux"; then
	git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
	ln -s -f "$HOME/.tmux/.tmux.conf" "$HOME/"
	cp "$HOME/.tmux/.tmux.conf.local" "$HOME/"
fi

# Setup zsh and zprezto.
# https://github.com/sorin-ionescu/prezto
#
if ! test -d "$HOME/.zprezto"; then
	which zsh || sudo apt-get install -y zsh
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
	zsh -s <<-EOF
		setopt EXTENDED_GLOB
		for rcfile in $HOME/.zprezto/runcoms/^README.md(.N); do
			ln -s \$rcfile $HOME/.\${rcfile:t}
		done
	EOF
	sed -i "s/  'prompt'/  'syntax-highlighting' 'history-substring-search'/" "$HOME/.zpreztorc"
	sed -i "s/\(zstyle ':prezto:module:prompt' theme\)/#\1/" "$HOME/.zpreztorc"
	cat .zshrc >> ~/.zshrc
	chsh -s "$(which zsh)" "$(id -un)"
fi

# Setup prompt.
# https://starship.rs/
#
if ! test -f "$HOME/.config/starship.toml"; then
	curl -sS https://starship.rs/install.sh | sh
	mkdir "$HOME/.config"
	cp starship.toml "$HOME/.config/starship.toml"
fi