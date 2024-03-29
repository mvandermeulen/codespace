# My aliases

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ls stuff, most are set in lib/directories.zsh
# I use lsd (https://github.com/Peltoche/lsd) for certain listings
alias ls='ls -G'
alias l='lsd -l'
alias la='lsd -la'
alias lt='ls -ltFho'   #long list,sorted by date,show type,human readable
alias ldot='ls -ld .*' #list dot files

# CD Shortcuts
alias d="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias docs="cd ~/Documents"
alias sites="cd ~/Sites"
alias p="cd ~/Projects"
alias omz="cd ~/.oh-my-zsh"
alias omzc="cd ~/.oh-my-zsh/custom"

# Quick edit to my aliases and zshrc config
alias zshrc="vim ~/.zshrc"
alias aliases="vim ~/.oh-my-zsh/custom/myaliases.zsh"
alias galiases="cat ~/.oh-my-zsh/plugins/git/git.plugin.zsh | grep alias"

# Git 
alias gs='git status'

# Spotify
# it's occasionally convenient to control spotify in the terminal ¯\_(ツ)_/¯
alias sptf="spotify"
alias sptfs="spotify status"
alias sptfp="spotify play"
alias sptfpa="spotify pause"
alias sptfn="spotify next"
alias sptfpr="spotify prev"
alias sptfv="spotify vol"
alias sptfvu="spotify vol up"
alias sptfvd="spotify vol down"

# Some docker and composer things
alias flushmagento='php bin/magento cache:flush'
alias deploystatic='php bin/magento setup:static-content:deploy --area=frontend -f'

alias dcup='docker-compose up -d'
alias dc='docker-compose'
alias cu='composer update --prefer-source --ignore-platform-reqs'

#todo.txt-cli https://github.com/todotxt/todo.txt-cli
if [ -z "$TODOTXT_DEFAULT_ACTION" ]; then
  # typing 't' by itself will list current todos
  export TODOTXT_DEFAULT_ACTION=ls
fi

alias t='todo.sh -c -A'
alias tls="todo.sh ls"
alias ta="todo.sh a"
alias trm="todo.sh rm"
alias tdo="todo.sh do"
alias tpri="todo.sh pri"

# Colored up cat
# Install Pygments first - "sudo easy_install Pygments"
# and pigments material theme: https://github.com/horosgrisa/pygments-style-material
alias cat='pygmentize -O style=material -f console256 -g'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias flushit="sudo killall -HUP mDNSResponder; sleep 2;"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# JavaScriptCore REPL
jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc";
[ -e "${jscbin}" ] && alias jsc="${jscbin}";
unset jscbin;

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "${method}"="lwp-request -m '${method}'"
done

# Make Grunt print stack traces by default
command -v grunt > /dev/null && alias grunt="grunt --stack"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
