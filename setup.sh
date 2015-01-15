echo "Removing old stuff"
rm -rf ~/.vim
rm ~/.bashrc
rm ~/.vimrc

echo "Creating ~/.vim/bundle & ~/.vim/colors"
mkdir -p ~/.vim/bundle/
mkdir -p ~/.vim/colors/

echo "Downloading molokai"
curl -G https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -o ~/.vim/colors/molokai.vim

echo "Downloading Vundle"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Creating ~/.vimrc and ~/.bashrc soft links"
ln -s dotfiles/vimrc ~/.vimrc
ln -s dotfiles/bashrc ~/.bashrc

echo "Installing vim plugins"
vim +PluginInstall +qall

echo "Reloading shell"
source ~/.bashrc
