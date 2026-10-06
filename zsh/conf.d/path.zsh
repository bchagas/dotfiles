# PATH and general environment

# Prepend/append only when the entry is absent. Re-sourcing this file (a nested
# shell, `source ~/.zshrc`, an `exec zsh` from a plugin) would otherwise push
# Homebrew back to the front of PATH and override whatever nvm or rbenv had
# already put there — which is how a `nvm use` ends up silently ignored.
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}
path_append() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

# Homebrew lives in /opt/homebrew on Apple Silicon and /usr/local on Intel
if [[ -z $HOMEBREW_PREFIX ]]; then
  [[ -x /opt/homebrew/bin/brew ]] && HOMEBREW_PREFIX=/opt/homebrew || HOMEBREW_PREFIX=/usr/local
fi
export HOMEBREW_PREFIX
export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/Library/pnpm"

path_prepend "$GOPATH/bin"
path_prepend "$PNPM_HOME"
path_prepend "$HOMEBREW_PREFIX/sbin"
path_prepend "$HOMEBREW_PREFIX/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOMEBREW_PREFIX/opt/python/libexec/bin"
path_append  "$HOME/.maestro/bin"

export GPG_TTY=$(tty)

# direnv loads ~/dev/ds/.env (load_dotenv = true in direnv.toml), which is ~180
# variables. The default log prints every name on entering and leaving the repo,
# which floods the terminal and puts secret names on screen. Empty = no log,
# loading itself is untouched.
export DIRENV_LOG_FORMAT=

# ds-scripts
path_prepend "$HOME/dev/ds-scripts"
