#!/bin/sh
SESSION="vscode`pwd | md5`"
#if ! command -v tmux > /dev/null; then
if [ ! -f "/usr/local/bin/tmux" ]; then
  echo "tmux command not found. Starting zsh in 3 seconds..."
  sleep 3
  zsh -l
else
  TERM=screen-256color-bce /usr/local/bin/tmux attach-session -d -t $SESSION || TERM=screen-256color-bce /usr/local/bin/tmux new-session -s $SESSION
  #tmux attach-session -d -t ${PWD##*/} || tmux attach-session -d -t $SESSION || tmux new-session -s $SESSION
fi