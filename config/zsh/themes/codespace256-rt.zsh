function git_repo_name() {
# if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  if git remote get-url origin > /dev/null 2>&1; then
    echo "$(basename $(git remote get-url origin) | cut -f 1 -d '.'):"
  elif git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "git:"
  fi
}

# git prompt BEFORE pwd
# PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT+=' %{$fg_bold[blue]%}$(git_repo_name)'
# PROMPT+='%{$reset_color%}$(git_prompt_info)'
# PROMPT+='%{$fg[cyan]%}%c  %{$reset_color%}'

# git prompt AFTER pwd
# PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

# calibrated for these terminal colors:
# green #7bd88f
# cyan #5ad4e6
# blue #fd9353
# red #fc618d
# yellow #fce566
#PROMPT="%{$fg_bold[green]%} "
#PROMPT+='%{$fg[cyan]%}%c %{$reset_color%}'
#PROMPT+='%{$fg_bold[blue]%}$(git_repo_name)'
#PROMPT+='%{$reset_color%}$(git_prompt_info)'
#ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# closest approximation with 256 colors
eval _green='$FG[079]'
eval _cyan='$FG[081]'
eval _blue='$FG[209]'   # actually orange
eval _red='$FG[204]'
eval _yellow='$FG[228]'
#eval tw_yellow='$FG[221]'
PROMPT="%{$FX[bold]$_green%} # "
PROMPT+='%{$_cyan%}%c %{$reset_color%}'
PROMPT+='%{$FX[bold]$_blue%}$(git_repo_name)'
PROMPT+='%{$reset_color%}$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FX[bold]$_blue%}(%{$FX[no_bold]$_red%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$_blue%}) %{$_yellow%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$_blue%})"