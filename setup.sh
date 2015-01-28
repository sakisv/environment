prefix="=====>"
echo "$prefix Removing old stuff"
rm -rf ~/.vim
rm ~/.bashrc
rm ~/.vimrc
rm ~/.bash_aliases
rm ~/.git-completion.bash
rm ~/.git-prompt.sh

echo "$prefix Creating ~/.vim/bundle & ~/.vim/colors"
mkdir -p ~/.vim/bundle/
mkdir -p ~/.vim/colors/

echo "$prefix Downloading molokai"
curl -Gk https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -o ~/.vim/colors/molokai.vim

echo "$prefix Downloading Vundle"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "$prefix Downloading latest git-completion && git-prompt"
curl -Gk https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
curl -Gk https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

echo "$prefix Creating soft links for ~/.bashrc, ~/.vimrc, ~/.bash_aliases"
path=`pwd`
ln -s $path/dotfiles/vimrc ~/.vimrc
ln -s $path/dotfiles/bashrc ~/.bashrc
ln -s $path/dotfiles/bash_aliases ~/.bash_aliases

echo "$prefix Installing vim plugins"
vim +PluginInstall +qall

echo "$prefix Reloading shell"
source ~/.bashrc
