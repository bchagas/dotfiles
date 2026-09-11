# Work-specific setup (nu CLI, monorepo, mobile SDKs)
export NU_HOME=${HOME}/dev

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

alias nuStartDay='nu update && nu certs setup && nu-br aws shared-role-credentials refresh -i && nu auth get-access-token && nu codeartifact login maven'
