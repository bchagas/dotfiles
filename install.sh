here=`pwd`
echo 'Deletando arquivos antigos'
rm -Rf $HOME/.autotest
rm -Rf $HOME/.zshrc
rm -Rf $HOME/.zshenv
rm -Rf $HOME/.inputrc
rm -Rf $HOME/.gemrc
rm -Rf $HOME/.gitconfig
rm -Rf $HOME/.gitignore
rm -Rf $HOME/.ssh/config
rm -Rf $HOME/.vimrc
rm -Rf $HOME/.bash
echo '=========='
echo 'Adicionando novos arquivos'
clear
echo 'Adicionando novos arquivos'
ln -s $here/autotest $HOME/.autotest
ln -s $here/zshrc $HOME/.zshrc
ln -s $here/zshenv $HOME/.zshenv
ln -s $here/inputrc $HOME/.inputrc
ln -s $here/gemrc $HOME/.gemrc
ln -s $here/gitconfig $HOME/.gitconfig
ln -s $here/gitignore $HOME/.gitignore
ln -s $here/sshconfig $HOME/.ssh/config
ln -s $here/vimrc $HOME/.vimrc
ln -s $here/bash $HOME/.bash
echo 'Atualizando Terminal'
source $HOME/.zshrc

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE

echo 'Finalizando'
