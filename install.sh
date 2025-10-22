here=`pwd`
echo 'Deletando arquivos antigos'
rm -Rf $HOME/.autotest
rm -Rf $HOME/.zshrc
rm -Rf $HOME/.zshenv
rm -Rf $HOME/.gemrc
rm -Rf $HOME/.gitconfig
rm -Rf $HOME/.gitignore
rm -Rf $HOME/.ssh/config
rm -Rf $HOME/.vimrc
echo '=========='
echo 'Adicionando novos arquivos'
clear
echo 'Adicionando novos arquivos'
ln -s $here/zshrc $HOME/.zshrc
ln -s $here/zshenv $HOME/.zshenv
ln -s $here/gitconfig $HOME/.gitconfig
ln -s $here/gitignore $HOME/.gitignore
ln -s $here/sshconfig $HOME/.ssh/config
ln -s $here/vimrc $HOME/.vimrc
echo 'Atualizando Terminal'
source $HOME/.zshrc

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE

echo 'Finalizando'
