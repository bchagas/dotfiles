# PATH and general environment

# Homebrew lives in /opt/homebrew on Apple Silicon and /usr/local on Intel
if [[ -z $HOMEBREW_PREFIX ]]; then
  [[ -x /opt/homebrew/bin/brew ]] && HOMEBREW_PREFIX=/opt/homebrew || HOMEBREW_PREFIX=/usr/local
fi
export HOMEBREW_PREFIX
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"
export PATH=$PATH:$HOME/.maestro/bin

export GPG_TTY=$(tty)
