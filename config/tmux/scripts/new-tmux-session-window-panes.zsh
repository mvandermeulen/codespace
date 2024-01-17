#!/bin/zsh
# after: chmod 755 script.zsh

# start new session named 'codespace' or attach if it exists
tmux attach -t codespace || tmux new -s codespace -d -x "$(tput cols)" -y "$(tput lines)"

# blank window name
tmux rename-window ""

# create new right pane 25% width
tmux splitw -h -p 25

# split new right pane by a third
tmux selectp -t 2
tmux splitw -v -p 33

# split top pane once again, by half
tmux selectp -t 2
tmux splitw -v -p 50

# switch focus back to first pane
tmux selectp -t 1

# attach to session
tmux attach -t codespace