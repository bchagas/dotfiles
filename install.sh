here=`pwd`
ln -s $here/bash $HOME/.bash
ln -s $here/bash_profile $HOME/.bash_profile
ln -s $here/autotest $HOME/.autotest
ln -s $here/caprc $HOME/.caprc
ln -s $here/finder-path.applescript $HOME/.finder-path.applescript
ln -s $here/gitconfig $HOME/.gitconfig
ln -s $here/gitignore $HOME/.gitignore
ln -s $here/irbrc $HOME/.irbrc
ln -s $here/inputrc $HOME/.inputrc
ln -s $here/gemrc $HOME/.gemrc
ln -s $here/npmrc $HOME/.npmrc
ln -s $here/rvmrc $HOME/.rvmrc

mkdir $HOME/.bin
ln -s $here/grabbit $HOME/.bin
chmod +x $HOME/.bin/grabbit

curl http://github.com/paulhammond/webkit2png/raw/master/webkit2png > $HOME/.bin/webkit2png
chmod +x $HOME/.bin/webkit2png

mkdir -p $HOME/.ssh
ln -s $here/sshconfig $HOME/.ssh/config

source $HOME/.bash_profile

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE

open $here/IR_Black.terminal
