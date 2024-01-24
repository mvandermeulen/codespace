#!/bin/sh
# load the global configuration
SETUP_ROOT=$(readlink -f "$(dirname "$0")/../..")
. "$SETUP_ROOT/config.txt" || exit 1

# git configuration
# needs to run after apt configuration

set_git_cfg() {
  # set a global git configuration, unless it is already set
  cfg_key="$1"
  cfg_value="$2"
  cfg_example="$3"
  if [ -z "$(git config --global "$cfg_key")" ]; then
    if [ -z "$cfg_value" ]; then
      # if no value was provided, we need to ask the user
      echo "Please input a value for git config $cfg_key (example: $cfg_example): "
      read -r cfg_value
    fi
    echo "git config: setting $cfg_key to $cfg_value"
    git config --global "$cfg_key" "$cfg_value"
  fi
}

# options in alphabetical order by key for easier readability
# most of them from here: https://gist.github.com/tdd/470582
set_git_cfg alias.aliases "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'"  # List available aliases
set_git_cfg alias.oops "commit --amend --no-edit"  # Useful when you have to update your last commit with staged files without editing the commit message.
set_git_cfg color.ui auto  # enable colors when supported
set_git_cfg core.autocrlf input  # only change EOL terminators on push
set_git_cfg core.ignorecase false  # useful on Windows
set_git_cfg core.whitespace "cr-at-eol"
set_git_cfg diff.colorMoved zebra  # code that moved is shown in a different colour
set_git_cfg diff.mnemonicPrefix true  # Use better, descriptive initials (c, i, w) instead of a/b.
set_git_cfg diff.renames true  # Show renames/moves as such
set_git_cfg fetch.prune true  # clean up local git repo when fetching
set_git_cfg init.defaultBranch "master"
set_git_cfg init.templateDir "$GIT_TEMPLATE_DIR"  # used by pre-commit
set_git_cfg pull.rebase true  # always rebase when pulling, don't create extra merge commits
set_git_cfg push.autoSetupRemote true  # Create remote branch if it doesn't exist
set_git_cfg push.default upstream  # Default push should only push the current branch to its push target, regardless of its remote name
set_git_cfg rebase.autoStash true # automatically stash any local changes before pulling
set_git_cfg rebase.autosquash true  # automatically squash fixup commits when rebasing
set_git_cfg tag.sort "version:refname"  # Sort tags as version numbers whenever applicable, so 1.10.2 is AFTER 1.2.0.
set_git_cfg user.name "" "$EXAMPLE_NAME"
set_git_cfg user.email "" "$EXAMPLE_EMAIL"

exit 0
