#!/usr/bin/env bash
# Sets up a Mac from these dotfiles. Safe to re-run: every step checks first and only
# does what is missing; files in the way go to ~/.dotfiles-backup/<timestamp>/.
# Usage: ./install.sh [--brew]   (--brew also installs everything in the Brewfile)
# Manual steps (keys, secrets, logins) are listed in README.md.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKED_UP=0
WARNINGS=""

have() { command -v "$1" >/dev/null 2>&1; }
warn() { WARNINGS="${WARNINGS}  - $1"$'\n'; echo "  warn    $1"; }

points_to_repo() { [ -L "$1" ] && [[ "$(readlink "$1")" == "$DOTFILES"/* ]]; }

# Clears a path: old links into this repo are removed, anything else is backed up
clear_path() {
  local target="$1" dest
  if points_to_repo "$target"; then
    rm "$target"
  elif [ -e "$target" ] || [ -L "$target" ]; then
    dest="$BACKUP/${target#"$HOME"/}"
    mkdir -p "$(dirname "$dest")"
    mv "$target" "$dest"
    echo "  backup  $target -> $dest"
    BACKED_UP=1
  fi
}

link() {
  local src="$DOTFILES/$1" dst="$2"
  if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
    echo "  ok      $dst"
    return
  fi
  clear_path "$dst"
  mkdir -p "$(dirname "$dst")"
  ln -sn "$src" "$dst"
  echo "  link    $dst -> $1"
}

# Homebrew lives in /opt/homebrew on Apple Silicon and /usr/local on Intel
load_brew() {
  local prefix
  for prefix in /opt/homebrew /usr/local; do
    if [ -x "$prefix/bin/brew" ]; then
      eval "$("$prefix/bin/brew" shellenv)"
      return 0
    fi
  done
  return 1
}

# Links first: nothing below can leave the machine without its config
echo 'Linking files'
mkdir -p -m 700 "$HOME/.ssh"
link zsh/zshenv      "$HOME/.zshenv"
link zsh/zshrc       "$HOME/.zshrc"
link zsh/p10k.zsh    "$HOME/.p10k.zsh"
link git/config      "$HOME/.config/git/config"
link git/ignore      "$HOME/.config/git/ignore"
link ssh/config      "$HOME/.ssh/config"
link vim/vimrc       "$HOME/.vimrc"
link nvim            "$HOME/.config/nvim"
link emacs/spacemacs "$HOME/.spacemacs"

# Old layout: git read ~/.gitconfig and ~/.gitignore
for legacy in "$HOME/.gitconfig" "$HOME/.gitignore"; do
  if points_to_repo "$legacy"; then
    rm "$legacy"
    echo "  remove  $legacy (link antigo)"
  fi
done
if [ -e "$HOME/.gitconfig" ]; then
  warn "~/.gitconfig exists and overrides ~/.config/git/config"
fi

# Machine-local files, never versioned (contents come from the old Mac, see README)
for f in "$HOME/.zshrc.local" "$HOME/.ssh/config.local"; do
  if [ ! -e "$f" ]; then
    touch "$f" && chmod 600 "$f"
    echo "  create  $f"
  fi
done

echo 'Checking dependencies'
# Command Line Tools: git and the C compiler (treesitter parsers)
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo 'Finish the Command Line Tools install, then run install.sh again'
  exit 1
fi

if ! load_brew; then
  echo '  installing Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
  load_brew || warn "Homebrew was not installed; brew packages were skipped"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo '  installing oh-my-zsh'
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" || warn "failed to clone oh-my-zsh"
fi

if [ ! -d "$HOME/.emacs.d" ]; then
  echo '  installing Spacemacs'
  git clone --depth=1 https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d" || warn "failed to clone Spacemacs"
fi

# Claude Code (native installer: ~/.local/bin/claude, auto-updates); used by claudecode.nvim
if ! have claude && [ ! -x "$HOME/.local/bin/claude" ]; then
  echo '  installing Claude Code'
  curl -fsSL https://claude.ai/install.sh | bash || warn "failed to install Claude Code"
fi

# Required by git/config but installed outside the Brewfile on the original Mac:
# gpg signs every commit and tag, git-lfs is a required filter
if have brew; then
  have gpg     || brew install --cask gpg-suite || warn "failed to install GPG Suite"
  have git-lfs || brew install git-lfs          || warn "failed to install git-lfs"
fi

if [ "${1:-}" = "--brew" ]; then
  if have brew; then
    echo 'Installing Brewfile packages'
    brew bundle --file="$DOTFILES/Brewfile" || warn "brew bundle finished with errors (run it again to see what is missing)"
  else
    warn "--brew ignored: Homebrew is not installed"
  fi
fi

# Finder shows the full path in the window title (restarts Finder only when it changes)
if [ "$(defaults read com.apple.finder _FXShowPosixPathInTitle 2>/dev/null)" != 1 ]; then
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
  killall Finder 2>/dev/null || true
fi
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE

if [ "$BACKED_UP" = 1 ]; then echo "Backups in $BACKUP"; fi
if [ -n "$WARNINGS" ]; then printf 'Warnings:\n%s' "$WARNINGS"; fi
echo 'Done. Open a new terminal (or run: exec zsh)'
echo 'Manual steps (SSH/GPG keys, secrets, logins): see README.md'
