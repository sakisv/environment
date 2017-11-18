#!/bin/bash
set -e
prefix="=====>"
path=`pwd`
dotfiles_dir="${path}/dotfiles"

if [ `uname -s` == 'Darwin' ]; then
    if hash brew 2>/dev/null; then
        echo "${prefix} Installing coreutils with brew"
        brew install coreutils > /dev/null
    else
        echo "brew is not installed. Exiting..."
        exit 1
    fi
fi

echo "${prefix} Removing old stuff..."
rm -rf ~/.vim > /dev/null || echo "${prefix} .vim/ not found"
declare -a files=("bashrc" "vimrc" "bash_aliases" "git-completion.bash" "git-prompt.sh" "gitconfig" "gitignore" "tmux.conf")

for i in ${files[@]}; do
    if [[ -L ~/.${i} ]]; then
        rm ~/.${i}
    elif [[ -f ~/.${i} ]]; then
        mv ~/.${i} ~/.${i}.bak
    fi
done

echo "${prefix} Creating ~/.vim/bundle & ~/.vim/colors..."
mkdir -p ~/.vim/bundle/ > /dev/null
mkdir -p ~/.vim/colors/ > /dev/null

echo "${prefix} Downloading molokai..."
curl -Gk https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -o ~/.vim/colors/molokai.vim > /dev/null

echo "${prefix} Downloading Vundle..."
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null

echo "${prefix} Downloading latest git-completion && git-prompt..."
curl -Gk https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash > /dev/null
curl -Gk https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh > /dev/null

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "${prefix} Cloning tmux-plugins..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "${prefix} Creating symlinks..."
for i in ${files[@]}; do
    if [[ ! -f ~/.${i} ]]; then
        ln -s ${dotfiles_dir}/${i} ~/.${i} > /dev/null
    fi
done

echo "${prefix} Installing vim plugins..."
vim +PluginInstall +qall

echo "${prefix} Reload your shell for changes to take place..."

exit 0
