# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh
export NU_HOME=${HOME}/dev/nu
export NUCLI_HOME=${NU_HOME}/nucli
export PATH=${NUCLI_HOME}:${PATH}
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion.d
eval "$(rbenv init - zsh)"

# {mark} START IT-ENG JAMF SETUP MOBILE ZSHRC
export MONOREPO_ROOT="$NU_HOME/mini-meta-repo"
export PATH="$PATH:$MONOREPO_ROOT/monocli/bin"
export FLUTTER_SDK_HOME="$HOME/sdk-flutter"
export FLUTTER_ROOT="$FLUTTER_SDK_HOME"
export PATH="$PATH:$FLUTTER_SDK_HOME/bin:$NU_HOME/.pub-cache/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
# {mark} END IT-ENG JAMF SETUP MOBILE ZSHRC

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias ..='cd ..'
alias gl="git log --oneline --graph --color --pretty=format:'(%an) - %s - %h '"
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias cat='bat'
alias ag='ag --path-to-ignore ~/.ignore'

#misc
alias gitx="/Applications/GitX.app/Contents/MacOS/GitX &"
alias psgrep="ps aux | egrep -v egrep | egrep"
alias top="top -o rsize"
alias make="make -j 2"
alias workspace="cd /Users/bruno.chagas/dev/nu"
alias dotfiles="cd /Users/bruno.chagas/Documents/dotfiles/"
alias dnsFlush="sudo killall -HUP mDNSResponder"
alias vundle='vim +BundleInstall +qall'
alias nuStartDay='nu update && nu certs setup && nu-br aws shared-role-credentials refresh -i && nu auth get-access-token && nu codeartifact login maven'
