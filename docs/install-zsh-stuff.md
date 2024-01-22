# Making a Nice ZSH Environment

- [Making a Nice ZSH Environment](#making-a-nice-zsh-environment)
  - [Introduction](#introduction)
  - [Install iTerm2](#install-iterm2)
  - [(Optional) Change your default shell](#optional-change-your-default-shell)
  - [Install Homebrew](#install-homebrew)
  - [Install oh-my-zsh](#install-oh-my-zsh)
  - [Set up your shell preference files](#set-up-your-shell-preference-files)
    - [zshenv](#zshenv)
    - [zshrc](#zshrc)
    - [(Optional) Bundled Modules and Functions](#optional-bundled-modules-and-functions)
  - [Install powerlevel10k](#install-powerlevel10k)
    - [(Optional) Powerlevel10k custom prompts](#optional-powerlevel10k-custom-prompts)
  - [(Optional) Install zplug](#optional-install-zplug)
  - [Install fd](#install-fd)
  - [Install ripgrep](#install-ripgrep)
  - [Install bat](#install-bat)
  - [Install fzf](#install-fzf)
  - [Install asdf](#install-asdf)
  - [(Optional) Install broot](#optional-install-broot)
  - [(Optional) Install ranger](#optional-install-ranger)
  - [(Optional) Install difftastic](#optional-install-difftastic)
  - [Set up keyboard shortcuts](#set-up-keyboard-shortcuts)
  - [Git](#git)
  - [ITerm2 Tab Colours](#iterm2-tab-colours)
  - [ZSH Benchmark](#zsh-benchmark)
  - [The End](#the-end)

## Introduction

![powerlevel10k configured prompt](https://i.stack.imgur.com/WabwR.png)

This document is intended to provide a quick overview of getting your new MacOS shell environment configured and useful. It is not going to be an exhaustive step-by-step and won't hand-hold you.

To use this guide you must already be familiar with basic shell concepts such as aliases and variables, as well as editing files on the command line.

If you've been given this guide and already feel lost, don't worry, here are some links to get you started! There's a lot of great, free tutorials out there to get you comfortable working with files in the command line. If you're beginning your journey, you'll soon find out how incredibly powerful the command line is. Welcome and good luck!

* <https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Understanding_client-side_tools/Command_line>
* <https://www.codecademy.com/learn/learn-the-command-line>
* <https://www.digitalocean.com/community/tutorials/a-linux-command-line-primer>

After installing each tool, you will need to reopen your terminal. `CMD + t` opens a new tab in iTerm, and then you can just close the old tab with the middle mouse button or with `CTRL + d` in the terminal you want to close.

Documentation for zsh can be found [here](https://zsh.sourceforge.io/Doc/) and I *highly* recommend downloading the PDF manual to your workstation so you have something local to refer to in case the zsh site is unavailable.

## Install iTerm2

Get the stable release from <https://iterm2.com/downloads.html>

## (Optional) Change your default shell

If your Mac has been upgraded from Mojave (10.14) or earlier, your default shell may still be bash. Switch it via the `chsh` utility.

## Install Homebrew

Homebrew is a package manager, much like `apt`, `dnf`, or `pacman`. It requires the Xcode command line tools: `xcode-select --install` or https://developer.apple.com/download/all/) or Xcode.

Go to <https://brew.sh/> and use the command line to install it.

## Install oh-my-zsh

Oh-my-zsh (omz for short) is a framework for themes, plugins, and more for zsh.

Go to <https://ohmyz.sh/> and use the command line to install oh-my-zsh.

Update it with `omz update` and [read the docs](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins-Overview) on all the useful plugins it provides. I use the following:
```zsh
plugins=(git ripgrep fd npm nvm docker)
```

## Set up your shell preference files

Read [this StackOverflow answer](https://apple.stackexchange.com/a/388623) to understand the order in which shell files are read and used.

### zshenv

`~/.zshenv` is read first. Use it for environment variables. Add the following lines to it:
```zsh
# store stuff here that you don't want in github
[[ -f $HOME/.zshenv-local ]] && source $HOME/.zshenv-local
```

Then create the `~/.zshenv-local` file. Now you can use this file for sensitive things like API tokens that you don't want stored in source control.

A better way to control your PATH variable is like this:
```zsh
# Only allow unique entries in the PATH variable
typeset -U path

# Easier to read PATH variable modification:
path+=(
  "${HOME}/.local/bin"
  "${GOPATH}/bin"
  "${GOROOT}/bin"
)
```

That typeset command makes sure only unique entries are in your PATH. Then you can add extra lines into that path block, making it easier to see what you have added.

To view your PATH in a similar way, use `echo ${PATH} | sed -e $'s/:/\\\n/g'`.

Some other good default environment variables:
```zsh
export TMPDIR="${HOME}/.tmp"
export EDITOR="vim"
```

### zshrc

If you ssh into this machine then this might be useful to control your omz prompt:
```zsh
if [[ -n $SSH_CONNECTION ]]; then
  ZSH_THEME="afowler"
else
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi
```

Add an alias for that PATH echo command if you want:
```zsh
alias ep="echo ${PATH} | sed -e $'s/:/\\\n/g'"
```

If you intend to share your shell init files between Linux and MacOS, use the `$OSTYPE` variable to decide whether to set something:
```zsh
# depends on 'brew install grep'
[[ $OSTYPE =~ ^darwin.* ]] && alias grep='ggrep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
```

To only load a file if it exists, use something like this:
```zsh
# helper function to set AWS environment variables
[[ -f $HOME/.aws-functions.zsh ]] && source $HOME/.aws-functions.zsh
```

You can also do the same with commands:
```zsh
# Kubernetes completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Helm completion
[[ $commands[helm] ]] && source <(helm completion zsh)

# Podman completion
[[ $commands[podman] ]] && source <(podman completion zsh)
```


Functions can be simple and very useful:
```zsh
# Marky Mark and the Function Bunch

# depends on 'unalias gcd' and 'brew install git'
function gcd
{
  git clone $1 && cd "$(basename "$_" .git)"
}

function mcd
{
  command mkdir $1 && cd $1
}
```

### (Optional) Bundled Modules and Functions

There's some optional [modules for zsh](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html) that add features you may find useful. For example, the `zsh/datetime` module makes available a command, `strftime`, and several environment variables including the current Unix epoch time.

To load a module, use `zmodload`:
```zsh
zmodload zsh/datetime
```

Functions bundled with zsh can be [browsed in github](https://github.com/zsh-users/zsh/tree/master/Functions). They can be loaded using `autoload`:
```zsh
autoload zmv
```

The function `zmv`, used in the example above, is a wildcard renaming function:
```zsh
$ ls -1
pic01.PNG
pic02.PNG
pic03.PNG

$ zmv '(*).PNG' '$1.png'

$ ls -1
pic01.png
pic02.png
pic03.png
```

## Install powerlevel10k

Powerlevel10k is a fast command line prompt. It supports displaying the status of many tools like `nvm`, `virtualenv`, `terraform`, or the AWS command line.

Go to the [omz install instructions for p10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh) and follow them. Then run `p10k configure`. It will guide you through setting up your prompt. Mine is set up like this:

![powerlevel10k configured prompt](https://i.stack.imgur.com/WabwR.png)

(The epoch display below the clock in that prompt is a custom function, see the next section)

To get that style prompt, I chose the following options:
* install meslo nerd font (y) (I actually have source code pro nerd font installed and use that, but meslo is a great choice to start with)
* answer the font/glyph setup questions
* prompt style: classic prompt (option 2)
* character set: unicode (1)
* prompt colour: dark (3)
* show current time? 24 hour format (2)
* prompt separators: angled (1)
* prompt heads: sharp (1)
* prompt tails: flat (1)
* prompt height: 2 lines (2)
* prompt connection: disconnected (1)
* prompt frame: no frame (1)
* prompt spacing: sparse (2)
* icons: any icons (2)
* prompt flow: concise (1)
* enable transient prompt: no transient prompt (n)
* instant prompt mode: verbose instant prompt (1)

Then save your ~/.p10k.zsh file

Powerlevel10k has a massive amount of customization options. Have fun exploring them!

### (Optional) Powerlevel10k custom prompts

It's pretty easy to create custom prompt segments for p10k, just refer to the output of the command `p10k help segment`.

I wrote a couple of segments that are useful for me:
```zsh
  function prompt_epoch() {
    printf -v COMMA_EPOCH "%'d" ${EPOCHSECONDS}
    p10k segment -f 66 -i 﨟 -t ${COMMA_EPOCH}
  }

  function prompt_sessremain() {
    if [[ -v SESS_EXP_EPOCH ]]; then
      REMSEC=$(($SESS_EXP_EPOCH-$EPOCHSECONDS))

      if (( $REMSEC >= 0 )); then
        REMAINING=$(gdate -d @${REMSEC} -u +"%H:%M:%S")
        p10k segment -f 30 -i  -t ${REMAINING}
      else
        p10k segment -f 124 -i  -t "00:00"
      fi
    fi
  }
```

There are 2 main prompt arrays defined in p10k, `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` and `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`. These 2 arrays have function names added to them, minus the "prompt_" prefix. For the 2 functions defined above, they'd be added as `epoch` and `sessremain`.

The segment `epoch` uses printf to set the variable `COMMA_EPOCH` as the current Unix epoch with commas for readability. That string is then passed to the `p10k segment` function.

The segment `sessremain` gives the time between an epoch timestamp and the current time, in the format HH:MM:SS. This is useful to show the time remaining for something, and I personally use it to show the time remaining in an authentication session for a cloud provider. `EPOCHSECONDS` is already available to p10k through the `zsh/datetime` module, and `SESS_EXP_EPOCH` is set by whatever function you are using to set the future timestamp. To convert a timestamp to epoch seconds, you can use `gdate -d ${TIMESTAMP} -u +%s`. Because there may not be an authentication timestamp, I first test that the `SESS_EXP_EPOCH` variable has a value assigned to it, then check that the difference between timestamps is not negative.

## (Optional) Install zplug

Zplug can manage various add-ons for zsh. Get it from <https://github.com/zplug/zplug>. It's hugely flexible and can manage installing code from gists, local files, github repos, and more!

I installed it with:
```zsh
export ZPLUG_HOME=${HOME}/.zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME
```

I then added my config for zplug into my zshrc:
```zsh
# Next-gen(!) ZSH plugin manager
source $HOME/.zplug/init.zsh

# Syntax highlighting needs a faster computer,
# so this next line is optional. Try it out and see
# if you are comfortable with the speed
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# https://github.com/urbainvaes/fzf-marks store and jump to bookmarks in zsh
zplug "urbainvaes/fzf-marks"

# https://github.com/zsh-users/zsh-completions extra completions (optional)
zplug "zsh-users/zsh-completions"

# https://github.com/supercrabtree/k display directories
# in git with file status symbols, file age and size colours (not colour-blind friendly)
zplug "supercrabtree/k"

# Keep zplug itself up to date
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Then, source plugins and add commands to $PATH
zplug load
```

After opening a new shell, you may see a complaint from the powerlevel10k instant prompt. You can ignore it.

I then ran `zplug install` which should display:
```
[zplug] Start to install 5 plugins in parallel

 ✔  Installed!            zsh-users/zsh-syntax-highlighting
 ✔  Installed!            urbainvaes/fzf-marks
 ✔  Installed!            zsh-users/zsh-completions
 ✔  Installed!            zplug/zplug --> hook-build: success
 ✔  Installed!            supercrabtree/k

[zplug] Elapsed time: 9.3724 sec.
 ==> Installation finished successfully!
```

## Install fd

The tool `fd` is a faster, simpler, replacement for `find`. The [homepage](https://github.com/sharkdp/fd) has lots of useful examples.

Install [fd](https://github.com/sharkdp/fd) via homebrew: `brew install fd`

## Install ripgrep

Ripgrep replaces recursive grep. It's pretty amazing.

Install [ripgrep](https://github.com/BurntSushi/ripgrep) via homebrew: `brew install ripgrep`. Then read [the user guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md).

## Install bat

This is a syntax colouring replacement/supplement for `cat`. It is git and diff aware, so running bat on a file in a git repo will highlight any changes from the committed code. Install [bat](https://github.com/sharkdp/bat) via homebrew again: `brew install bat`. Then check out the [git repo](https://github.com/sharkdp/bat) for ways to configure and theme the output from bat.

## Install fzf

The utility `fzf` is an incredibly useful search tool. It will sort through text and display lines that match what you type. Sounds boring, but it is wonderful! The [homepage](https://github.com/junegunn/fzf) has usage and links to lots of examples.

Install [fzf](https://github.com/junegunn/fzf) via homebrew: `brew install fzf` then `$(brew --prefix)/opt/fzf/install`

This should add something like this to your zshrc:
```zsh
[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
```

## Install asdf

Install [asdf](https://github.com/asdf-vm/asdf) via git clone: `git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0`

Then add these lines to your `~/.zshrc`
```zsh
# source the asdf config if it exists
[[ -f $HOME/.asdf/asdf.sh ]] && source "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
```

Use it to manage things like `terraform`, `node`, and much more. Read about its plugins [here](https://github.com/asdf-vm/asdf-plugins)

## (Optional) Install broot

[Broot](https://github.com/Canop/broot) is a better way to navigate directory trees. It's installed via [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html): `cargo install broot`

## (Optional) Install ranger

[Ranger](https://github.com/ranger/ranger) is a multi-column file manager, much like Finder's column view. On MacOS, install it via homebrew: `brew install ranger`. Then generate the standard configuration using `ranger --copy-config=rc`.

## (Optional) Install difftastic

[Difftastic](https://github.com/Wilfred/difftastic) is a syntax-aware diff. Once you see its output, you'll wonder how you lived without it! It's installed via [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html): `cargo install difftastic`

It's incredibly useful paired with `git`, learn how to use it here: https://difftastic.wilfred.me.uk/git.html

## Set up keyboard shortcuts

In your ~/.zshenv, add:
```zsh
export FZF_DEFAULT_OPTS='--reverse --border --exact --height=50%'
export FZF_ALT_C_COMMAND='fd --type directory'
[[ $OSTYPE =~ ^darwin.* ]] && export FZF_CTRL_T_COMMAND="mdfind -onlyin . -name ."
```

This will add the following shortcuts:
* `CTRL + r` will search backwards through your zsh history. This is a fuzzy search, e.g. `terraform tfstate` will bring up all commands in history that have terraform and tfstate *anywhere* in the command line. Great for finding commands where you don't remember the exact syntax you used.
* `ESC + c` will search all directories below the current working directory then cd to the result. Great for quickly jumping to a deep directory.
* `CTRL + t` will use MacOS' Spotlight to search all files and directories below the current working directory then put that result on the command line, ready for a `CTRL + a` to add a command before it. Great for when you're not sure where you put that file. Alternatively, type your command then hit `CTRL + t` to add a file afterwards.

But there's more! You can use `fzf` with `git` for extra cool points!

## Git

Homebrew `git` is more up to date than the MacOS-bundled version. Install it with, you guessed it, `brew install git`. You'll need to make sure your PATH has `/usr/local/bin` *before* `/usr/bin`.

The file `~/.gitconfig` contains your user-wide settings. Here's some good defaults:
```gitconfig
[user]
	email = you@your.com
	name = Your Full Name
[core]
	editor = vim
	pager = less -FRX
[alias]
  lol = !git --no-pager log --graph --decorate --abbrev-commit --all --date=local -25 --pretty=format:\"%C(auto)%h%d %C(blue)%an %C(green)%cd %C(red)%GG %C(reset)%s\"
  fza = "!git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 git add"
  gone = "!f() { git fetch --all --prune; git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f"
[init]
	defaultBranch = main
```

Some definitions:
* `page = less -FRX`. `-F` means "quit less if output is less than one screen". `-R` means "Use raw control characters to correctly display colours". `-X` means "don't reinit the terminal" which in turn means "don't clear the terminal".
* `editor = vim`. Use the vim editor when composing commits.
* `defaultBranch = main`. Use `main` as the default name for the first branch of a new repo.
* `fza...`. When you run `git fza` you'll be given a list of changed files that you can toggle with `TAB`. Hitting `ENTER` will add/update those files in git, ready to commit. Very useful!!
* `lol...`. Displays the last 25 commits in a colourful tree style. Pretty!
* `gone...`. Removes branches that no longer exist in the remote repo.

## ITerm2 Tab Colours

[This gist](https://gist.github.com/aclarknexient/84ebe33c1879f92168530487528802c4) has functions to automatically set your iTerm2 tabs to different colours based on the command you run. For example, if you sign in to your cloud provider with `cloudlogin dev` you can turn the tab green, then when you sign into production, with `cloudlogin prod`, your tab will turn red. This gives you a visual indicator of which environment you are running commands in, and could prevent a production disaster! I've included a dichromatic-friendly palette too, plus palettes based on Solarized Dark and One Dark.

## ZSH Benchmark

Adding lots of functions to your zsh config may increase the time it takes to get from opening a terminal to a usable command prompt. There's a great benchmark utility from the maker of powerlevel10k to help you diagnose the functions that add the most time: <https://github.com/romkatv/zsh-bench>

## The End

If you've found parts of this document useful, please let me know in the comments below. If you have any useful functions or configuration that you'd like to share, please send them to anthonyclarka2 at gmail. Thank you for reading, you're awesome!

That's All, Folks!

