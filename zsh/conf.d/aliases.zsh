# Aliases
alias ..='cd ..'
alias gl="git log --oneline --graph --color --pretty=format:'(%an) - %s - %h '"
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
(( ! $+commands[bat] )) || alias cat='bat'
alias ag='ag --path-to-ignore ~/.ignore'
(( ! $+commands[nvim] )) || alias vim='nvim'

#misc
alias gitx="/Applications/GitX.app/Contents/MacOS/GitX &"
alias psgrep="ps aux | egrep -v egrep | egrep"
alias top="top -o rsize"
alias make="make -j 2"
alias workspace="cd $HOME/dev"
alias dotfiles="cd ${ZDOTFILES:h}"
alias dnsFlush="sudo killall -HUP mDNSResponder"
# Lock the screen right away, like Raycast's Lock Screen (private login.framework call;
# `pmset displaysleepnow` only locks after the "require password" delay)
alias lock="/usr/bin/python3 -c 'import ctypes; ctypes.CDLL(\"/System/Library/PrivateFrameworks/login.framework/login\").SACLockScreenImmediate()'"
