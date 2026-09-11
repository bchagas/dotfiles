# Language version managers
export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion.d

# Switch node version when entering a directory with .nvmrc or .node-version
if (( $+functions[nvm] )); then
  autoload -U add-zsh-hook
  _nvm_auto() {
    if [[ -f .nvmrc ]]; then nvm use --silent
    elif [[ -f .node-version ]]; then nvm use --silent "$(cat .node-version)"
    fi
  }
  add-zsh-hook chpwd _nvm_auto; _nvm_auto
fi

(( ! $+commands[rbenv] )) || eval "$(rbenv init - zsh)"
