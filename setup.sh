#!/usr/bin/env bash

COLOR_INFO='\033[1;30m'
COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_RESET='\033[0m'
PREFIX="=====>"

DOTFILES_DIR=$(pwd)/dotfiles

_info() {
    printf "${COLOR_INFO}${PREFIX}$1${COLOR_RESET}\n"
}
_success() {
    printf "${COLOR_SUCCESS}${PREFIX}$1${COLOR_RESET}\n"
}
_error() {
    printf "${COLOR_ERROR}${PREFIX}$1${COLOR_RESET}\n"
}
_done() {
    _info "Done"
}

handle_osx() {
    if [[ ! $(which brew) ]]; then
        _error "brew is not installed. Exiting..."
        exit 1
    fi
    _info "Installing coreutils with brew..."
    brew install coreutils > /dev/null
    _done
}

remove_old_files() {
    _info "Removing old stuff..."

    _info "Removing symlinks and creating backups of regular files"
    for item in "${DOTFILES_DIR}"/*; do
        # Skip over dirs
        [[ -d "${item}" ]] && continue

        filename=$(basename ${item})
        # if a .dotfile symlink exists remove it
        # if a non-symlink .dotfile exists back it up
        if [[ -L ~/.${filename} ]]; then
            _info "Removing symlink ${filename}"
            rm ~/.${filename}
        elif [[ -f ~/.${filename} ]]; then
            _info "Creating backup for ${filename} at ~/${filename}.bak"
            mv ~/.${filename} ~/.${filename}.bak
        fi
    done

    _done
}

configure_neovim() {
    NEOVIM_CONFIG_DIR="${HOME}/.config/nvim"
    NEOVIM_PLUG_VERSION=0.10.0
    NEOVIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/${NEOVIM_PLUG_VERSION}/plug.vim"

    if [[ ! $(which nvim) ]]; then
        _info "nvim not found, installing..."
        sudo apt install neovim
        _done
    fi

    _info "Downloading vim-plug ${NEOVIM_PLUG_VERSION}"
    curl --create-dirs -sSLo "${$HOME/.local/share}"/nvim/site/autoload/plug.vim ${NEOVIM_PLUG_URL}
    _done

    _info "Downloading molokai..."
    curl --create-dirs -sSLo ${NEOVIM_CONFIG_DIR}/colors/molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
}

[[ $(uname -s) == "Darwin" ]] && handle_osx
remove_old_files
configure_neovim

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
        ln -s ${DOTFILES_DIR}/${i} ~/.${i} > /dev/null
    fi
done

echo "${prefix} Installing vim plugins..."
vim +PluginInstall +qall

echo "${prefix} Reload your shell for changes to take place..."

exit 0
