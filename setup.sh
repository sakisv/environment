#!/usr/bin/env bash

COLOR_INFO='\033[1;30m'
COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_RESET='\033[0m'
PREFIX="----->  "

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

_download() {
    from=$1
    to=$2

    curl --create-dirs -LsSo $to $from
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

install_essentials() {
    sudo apt install -y \
        curl \
        direnv \
        silversearcher-ag
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
    NEOVIM_INIT="$(pwd)/config/nvim/init.vim"

    if [[ ! $(which nvim) ]]; then
        _info "nvim not found, installing..."
        sudo apt install neovim
        _done
    fi

    _info "Downloading vim-plug ${NEOVIM_PLUG_VERSION}"
    _download ${NEOVIM_PLUG_URL} ${HOME}/.local/share/nvim/site/autoload/plug.vim
    _done

    _info "Downloading molokai..."
    _download https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim ${NEOVIM_CONFIG_DIR}/colors/molokai.vim
    _done

    ln -s ${NEOVIM_INIT} ${NEOVIM_CONFIG_DIR}/init.vim

    _info "Installing vim plugins..."
    vim +PlugInstall +qall
}

configure_git() {
    _info "Downloading latest git-completion and git-prompt..."
    _download https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash ${HOME}/.git-completion.bash
    _download https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh ${HOME}/.git-prompt.sh
    _done
}

configure_tmux() {
    if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
        echo "${prefix} Cloning tmux-plugins..."
        git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    fi
}

configure_alacritty() {
    ALACRITTY_CONFIG_DIR="${HOME}/.config/alacritty"
    ALACRITTY_CONFIG="$(pwd)/config/alacritty/alacritty.yml"

    mkdir -p ${ALACRITTY_CONFIG_DIR}
    ln -s ${ALACRITTY_CONFIG} ${ALACRITTY_CONFIG_DIR}
}

create_symlinks() {
    _info "Creating symlinks..."
    for item in "${DOTFILES_DIR}"/*; do
        # Skip over dirs
        [[ -d "${item}" ]] && continue

        filename=${HOME}/.$(basename ${item})
        _error ${filename}
        if [[ -f ${filename} ]]; then
            _info "${filename} exists, skipping"
            continue
        fi
        ln -s ${item} ${filename}
    done
}


[[ $(uname -s) == "Darwin" ]] && handle_osx
install_essentials
remove_old_files
configure_neovim
configure_git
configure_tmux
configure_alacritty
create_symlinks

_success "Setup complete!"
_success "Reload your shell for changes to take place..."

exit 0
