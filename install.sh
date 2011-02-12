here=`pwd`
echo 'Deletando arquivos antigos'
rm -Rf $HOME/.autotest
rm -Rf $HOME/.bash_profile
rm -Rf $HOME/.inputrc
rm -Rf $HOME/.gemrc
rm -Rf $HOME/.gitconfig
rm -Rf $HOME/.gitignore
rm -Rf $HOME/.ssh/config
rm -Rf $HOME/.vimrc
rm -Rf $HOME/.bash
ln -s $here/autotest $HOME/.autotest
ln -s $here/bash_profile $HOME/.bash_profile
ln -s $here/inputrc $HOME/.inputrc
ln -s $here/gemrc $HOME/.gemrc
ln -s $here/gitconfig $HOME/.gitconfig
ln -s $here/gitignore $HOME/.gitignore
ln -s $here/sshconfig $HOME/.ssh/config
ln -s $here/vimrc $HOME/.vimrc
ln -s $here/bash $HOME/.bash

source $HOME/.bash_profile

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE
