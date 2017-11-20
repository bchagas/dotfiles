source $HOME/.bash/paths
source $HOME/.bash/config
source $HOME/.bash/aliases
source $HOME/.bash/completions
source $HOME/.bash/functions
eval "$(rbenv init -)"

export NVM_DIR="/Users/brunochagas/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
