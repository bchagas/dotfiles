# dotfiles

zsh, git, ssh, vim/nvim and Spacemacs configuration for macOS.

```
install.sh            links + dependencies (idempotent, backs up whatever it replaces)
Brewfile              Homebrew packages (brew bundle)
zsh/
  zshenv              EDITOR/VISUAL                          -> ~/.zshenv
  zshrc               instant prompt, oh-my-zsh, modules     -> ~/.zshrc
  p10k.zsh            powerlevel10k prompt                   -> ~/.p10k.zsh
  conf.d/             path, languages, work, aliases (sourced in that order)
git/config, git/ignore                                       -> ~/.config/git/
ssh/config            Includes only                          -> ~/.ssh/config
vim/vimrc                                                    -> ~/.vimrc
nvim/                                                        -> ~/.config/nvim
emacs/spacemacs                                              -> ~/.spacemacs
```

Machine-local files, **never versioned** (install.sh creates them empty, mode 600):

- `~/.zshrc.local`: secrets and per-machine variables (API keys)
- `~/.ssh/config.local`: ssh hosts

## New Mac

1. Clone over HTTPS (the SSH key is not on the machine yet). If git offers to install
   the Command Line Tools, accept and run the command again.

   ```sh
   git clone https://github.com/bchagas/dotfiles.git ~/Documents/dotfiles
   cd ~/Documents/dotfiles && ./install.sh --brew
   ```

   Besides the links and the Brewfile, the script installs whatever is missing:
   Homebrew, oh-my-zsh, Spacemacs, Claude Code, GPG Suite and git-lfs. It asks for the
   macOS password a few times. Anything that fails is reported as a warning at the end
   and does not stop the run; fix it and run the script again.

2. Copy over from the old Mac through a secure channel (AirDrop, 1Password; never
   through the repo):

   - `~/.zshrc.local` and `~/.ssh/config.local`
   - SSH keys: `~/.ssh/id_*` (then `chmod 600 ~/.ssh/id_*`)
   - the GPG key. **Without it every commit fails**, since git signs commits and tags:

     ```sh
     # on the old Mac
     gpg --export-secret-keys --armor C39C9F7547D42AD6 > gpg-key.asc
     # on the new Mac
     gpg --import gpg-key.asc && rm gpg-key.asc
     ```

3. Log in: `claude` (then `/login`), `gh auth login`, and `:Copilot setup` in nvim.
   Neovim plugins and treesitter parsers install themselves on first start.

4. In the terminal app, select the **Meslo LG M for Powerline** font (the Brewfile
   installs it).

5. Only if needed: sdkman (Java), Node (`nvm install`) and Ruby (`rbenv install`)
   versions, Flutter and the Android SDK (used by `zsh/conf.d/work.zsh`).

## Day to day

- `./install.sh` can be run at any time; it only does what is missing.
- After installing or removing brew packages, refresh the Brewfile:
  `brew bundle dump --force --file=Brewfile`. GPG Suite and Claude Code are deliberately
  not in the Brewfile: install.sh takes care of them.
- Work-only configuration lives in `zsh/conf.d/work.zsh`.
