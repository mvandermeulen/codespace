#!/bin/zsh
# after: chmod 755 script.zsh

# create new right pane 25% width
tmux splitw -h -p 20

# split new right pane by a third
tmux selectp -t 2
tmux splitw -v -p 33

# split top pane once again, by half
tmux selectp -t 2
tmux splitw -v -p 50

# switch focus back to first pane
tmux selectp -t 1