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
