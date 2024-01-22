#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

install-tmux() {
	pushd /tmp
	local tmux_src="/tmp/tmux"
	git clone --branch "$TMUX_VERSION" --depth 1 https://github.com/tmux/tmux.git "$tmux_src"
	pushd "$tmux_src"
	# libevent is a run-time requirement. *-dev are for the header files.
	apt-install libevent-2.1-7 libevent-dev libncurses-dev autoconf automake pkg-config bison
	sh autogen.sh
	./configure
	make
	sudo make install
	popd
	rm -rf "$tmux_src"
	sudo apt-get purge -y libevent-dev libncurses-dev autoconf automake pkg-config bison
	popd
}


sudo apt-get update

# Fix file permissions from the copy
sudo chown -R aghost-7:aghost-7 "$HOME/.config"
sudo chown aghost-7:aghost-7 /home/aghost-7/.config/tmux/tmux.conf

# Need to update package cache...
sudo apt-get update

install-powerline

install-tmux

# Cleanup cache
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get autoremove -y

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


# Configure tmux
cp $HOME/.dotfiles/tmux/.tmux.conf $HOME/
cp $HOME/.dotfiles/tmux/.tmux.conf $RHOME/
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
cp -r $HOME/.tmux $RHOME/.tmux
tmux start-server \
 && tmux new-session -d \
 && sleep 1 \
 && $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh \
 && tmux kill-server
mkdir -p $HOME/.tmux/scripts \
 && cp -r $HOME/.dotfiles/tmux/scripts $HOME/.tmux/
mkdir -p $RHOME/.tmux/scripts \
 && cp -r $HOME/.dotfiles/tmux/scripts $RHOME/.tmux/




