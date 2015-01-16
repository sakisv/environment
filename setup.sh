prefix="=====>"
echo "$prefix Removing old stuff"
rm -rf ~/.vim
rm ~/.bashrc
rm ~/.vimrc

echo "$prefix Creating ~/.vim/bundle & ~/.vim/colors"
mkdir -p ~/.vim/bundle/
mkdir -p ~/.vim/colors/

echo "$prefix Downloading molokai"
curl -Gk https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -o ~/.vim/colors/molokai.vim

echo "$prefix Downloading Vundle"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "$prefix Creating ~/.vimrc and ~/.bashrc soft links"
path=`pwd`
ln -s $path/dotfiles/vimrc ~/.vimrc
ln -s $path/dotfiles/bashrc ~/.bashrc

echo "$prefix Installing vim plugins"
vim +PluginInstall +qall

echo "$prefix Reloading shell"
source ~/.bashrc
