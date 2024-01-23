FROM ubuntu:22.04

ENV WORKDIR="/opt/workspace"

COPY . $WORKDIR/devenv

RUN /opt/workspace/devenv/scripts/install.sh \
    --set "DOTFILES_DIRECTORY=$WORKDIR/dotfiles" \
    --set "GRAPHICAL=false" \
    "zsh" "vim" "tmux" \
    "packages/development" \
    "docker/client-binary" \
    "kubernetes/helm" "kubernetes/helmsman" "kubernetes/kind" "kubernetes/kubectl" "kubernetes/sops" "kubernetes/telepresence" \
    "languages/go" "languages/rust"

WORKDIR $WORKDIR

CMD [ "zsh" ]
