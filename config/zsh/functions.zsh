#!/bin/bash

## ------------------ FUNCTIONS -------------------------

function doesCommandExist() {
  command -v "$1" &> /dev/null
}

function brew() {
  if doesCommandExist brew
  then
    command brew "$@"
    if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
      sketchybar --trigger brew_update
    fi
  fi
}

function tunnel-forwarding() {
  if [[ -n "$1" && -n "$2" ]]; then
    ssh -L ${2}:localhost:${2} ${1}
  else
    echo "Usage: tunnel-forwarding <ssh-host> <port-to-forward>"
  fi

}

function watch() {
  if [[ -n "$1" && -n "$2" ]]; then
    npx nodemon --exec $1 $2
  elif [[ -n "$1" ]]; then
    npx nodemon $1
  else
    echo "Usage:"
    echo "\t watch <program-file-path>"
    echo "\t watch <language> <program-file-path>"
    echo ""
    echo "Parameters:"
    echo "\t language:  Provide the language binary, If the language is not specified it will default to 'node'"
    echo "\t program-file-path:  The path of the file/directory to run"
  fi
}

## ----------------- ALIASES -------------------------

alias ..='cd ..'
alias ...='cd ../..'

# 'ls' replacement
if doesCommandExist exa
then
  alias ls='exa --icons'
fi

# Neovim + Coding
if doesCommandExist nvim
then
  alias vi='nvim'
  alias svi='sudo nvim'
  alias vgit='nvim -c :0G'
  alias arc='nvim ~/dev_scripts/aliases'
  alias trc='nvim ~/.config/kitty/kitty.conf'
  alias zrc='nvim ~/.zshrc'
fi

if doesCommandExist lazygit
then
  alias lg='lazygit'
fi

if doesCommandExist lazydocker
then
  alias ld='lazydocker'
fi

# dotfiles stuff

if doesCommandExist stow
then
  alias dotfiles='stow --target="$HOME" --dir="$HOME/projects/dotfiles"'
fi

if doesCommandExist git
then
  alias gc='git clone'
fi
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

# session management
if doesCommandExist tmux
then
  alias ts='tmux a || tmux new-session -s workspace'
  alias curl-atlnz='curl --socks5-hostname localhost:1080'
fi

if doesCommandExist fzf
then
  o() {
    selected=$(
      find \
        ~/projects ~/.config \
        -mindepth 1 -maxdepth 1 -type d |
      sed -r "s/^\/home\/[^\/]+\///g" |
      fzf --border=rounded --reverse --prompt="  ➡️  " --ansi \
        --header="🚀 Finder" --header-first \
        --pointer="🔥" \
        --padding 1,0 --margin 0,2,1,2 \
        --color="prompt:blue,prompt:bold,border:green,border:dim" \
        --color="fg+:yellow" \
        --color="hl:underline,hl+:underline,hl:magenta,hl+:magenta" \
        --color="info:green" \
        --preview='\
        gitdir="$(echo {})$(echo "/.git")" ;\
        if [ -e $gitdir ] ;\
        then ;\
          projectname=$(basename {}) ;\
          commitcount=$(git --git-dir=$gitdir \
          rev-list --all --count) ;\
          printf "\e[0;93m\e[1;34m $projectname \e[0m\n" ;\
          printf "\e[0;93m\e[0;34m branch\e[0m  " ;\
          git --git-dir=$gitdir \
          rev-parse --abbrev-ref HEAD ;\
          printf "\e[0;93m\e[0;34m commits\e[0m " ;\
          echo $commitcount ;\
          echo ;\
        fi;
      exa -1 --icons -T -L 3 \
        --group-directories-first -l --no-permissions --git-ignore\
        --no-user --no-filesize --changed --no-time {} ;\
        ' \
			--preview-window=border-left,50%
		    )
		    cd $selected &>/dev/null
		}
fi