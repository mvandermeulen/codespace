FROM ubuntu:latest
# Install base dependencies
RUN apt-get update \
    && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
        nano \
        bash \
    && rm -rf /var/lib/apt/lists/*

ENV NODE_VERSION v16.20.2
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN bash -i -c "nvm install --lts \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g @angular/cli@16.2.10"
RUN bash -i -c 'git config --global user.editor "nano" \
    && git config --global init.defaultBranch main \
    && git config --global user.name "selvalogesh" \
    && git config --global user.email "selvalogesh95@gmail.com"'
WORKDIR /home
# To keep the container awake, later for opening terminal into the container
CMD tail -f /dev/null