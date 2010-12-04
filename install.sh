here=`pwd`
ln -s $here/autotest $HOME/.autotest
ln -s $here/gitconfig $HOME/.gitconfig
ln -s $here/gitignore $HOME/.gitignore
ln -s $here/sshconfig $HOME/.ssh/config

source $HOME/.bash_profile

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE
