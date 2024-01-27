#!/bin/sh

git_command_context () {
  cd $1;
  shift;
  is_workdir=`git rev-parse --is-inside-work-tree`
  is_gitdir=`git rev-parse --is-inside-git-dir`
  is_basedir=`git rev-parse --is-bare-repository`
  my_gitdir=`git rev-parse --git-dir`
  git "--work-tree=`pwd`" "--git-dir=${my_gitdir}" "$@"
  cd $OLDPWD;
}

echo_if_dirty(){
  while read gitdir; do
    workdir=`dirname "$gitdir"`
    [ -z "`git_command_context "${workdir}" diff --shortstat 2>/dev/null | tail -n 1`" ] || echo "dirty:" $workdir
  done
}

find ${1:-./} -type d -name .git | echo_if_dirty