#!/bin/bash
set -e
prefix="=====>"

if [ `uname -s` == 'Darwin' ]; then
    if hash brew 2>/dev/null; then
        echo "$prefix Installing coreutils with brew"
        brew install coreutils > /dev/null
    else
        echo "brew is not installed. Exiting..."
        exit 1
    fi
fi

echo "$prefix Removing old stuff..."
rm -rf ~/.vim > /dev/null
rm ~/.bashrc > /dev/null
rm ~/.vimrc > /dev/null
rm ~/.bash_aliases > /dev/null
rm ~/.git-completion.bash > /dev/null
rm ~/.git-prompt.sh > /dev/null
rm ~/.screenrc > /dev/null

echo "$prefix Creating ~/.vim/bundle & ~/.vim/colors"
mkdir -p ~/.vim/bundle/ > /dev/null
mkdir -p ~/.vim/colors/ > /dev/null

echo "$prefix Downloading molokai"
curl -Gk https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -o ~/.vim/colors/molokai.vim > /dev/null

echo "$prefix Downloading Vundle"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null

echo "$prefix Downloading latest git-completion && git-prompt"
curl -Gk https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash > /dev/null
curl -Gk https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh > /dev/null

echo "$prefix Creating soft links for ~/.bashrc, ~/.vimrc, ~/.bash_aliases"
path=`pwd`
ln -s $path/dotfiles/vimrc ~/.vimrc > /dev/null
ln -s $path/dotfiles/bashrc ~/.bashrc > /dev/null
ln -s $path/dotfiles/bash_aliases ~/.bash_aliases > /dev/null
ln -s $path/dotfiles/screenrc ~/.screenrc > /dev/null

echo "$prefix Installing vim plugins"
vim +PluginInstall +qall

echo "$prefix Reloading shell"
source ~/.bashrc

exit 0
