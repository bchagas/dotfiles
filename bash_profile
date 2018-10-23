source $HOME/.bash/paths
source $HOME/.bash/config
source $HOME/.bash/aliases
source $HOME/.bash/completions
source $HOME/.bash/functions

export NVM_DIR="/Users/brunochagas/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/brunochagas/google-cloud-sdk/path.bash.inc' ]; then source '/Users/brunochagas/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/brunochagas/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/brunochagas/google-cloud-sdk/completion.bash.inc'; fi
export GPG_TTY=$(tty)

eval "$(rbenv init -)"
