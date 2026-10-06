# Language version managers
export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion.d

# Switch node version when entering a project with .nvmrc or .node-version.
# Walks up the tree: the file usually sits at the repo root, and cd-ing into a
# subdirectory should not leave the shell on whatever version it had before.
if (( $+functions[nvm] )); then
  autoload -U add-zsh-hook
  _nvm_auto() {
    local dir=$PWD
    while [[ -n $dir ]]; do
      if [[ -f $dir/.nvmrc ]]; then
        nvm use --silent "$(<$dir/.nvmrc)"
        return
      elif [[ -f $dir/.node-version ]]; then
        nvm use --silent "$(<$dir/.node-version)"
        return
      fi
      dir=${dir:h}
      [[ $dir == / ]] && break
    done
  }
  add-zsh-hook chpwd _nvm_auto; _nvm_auto
fi

(( ! $+commands[rbenv] )) || eval "$(rbenv init - zsh)"
