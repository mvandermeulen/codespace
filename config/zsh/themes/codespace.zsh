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
# calibrated for these terminal colors:
# green #7bd88f
# cyan #5ad4e6
# blue #fd9353    # actually orange
# red #fc618d
# yellow #fce566
# PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT="%{$fg_bold[green]%} "
PROMPT+='%{$fg[cyan]%}%c %{$reset_color%}'
PROMPT+='%{$fg_bold[blue]%}$(git_repo_name)'
PROMPT+='%{$reset_color%}$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"