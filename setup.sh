#!/usr/bin/env bash

COLOR_DEBUG='\033[1;33m'
COLOR_INFO='\033[1;34m'
COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_RESET='\033[0m'
PREFIX="----->  "

DOTFILES_DIR=$(pwd)/dotfiles


_debug() {
    printf "${COLOR_DEBUG}${PREFIX}[DEBUG] $1${COLOR_RESET}\n"
}
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

install_essentials_osx() {
    if [[ ! $(which brew) ]]; then
        _error "brew is not installed. Exiting..."
        exit 1
    fi
    _info "Installing coreutils..."
    brew install coreutils > /dev/null

    _info "Installing fzf..."
    brew install fzf > /dev/null

    _info "Installing gnupg..."
    brew install gnupg > /dev/null

    _info "Installing curl..."
    brew install curl > /dev/null

    _info "Installing direnv..."
    brew install direnv > /dev/null

    _info "Installing ripgrep..."
    brew install ripgrep > /dev/null

    _info "Installing neovim..."
    brew install neovim > /dev/null

    _info "Installing pinentry-mac..."
    brew install pinentry-mac > /dev/null

    _info "Installing ykman..."
    brew install ykman > /dev/null
    _done
}

install_essentials() {
    _info "Installing basic apps..."
    sudo apt install -y \
        curl \
        direnv \
        python3-pip \
        scdaemon \
        silversearcher-ag

    sudo pip3 install black
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
    nvim +PlugInstall +qall
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
        if [[ -f ${filename} ]]; then
            _info "${filename} exists, skipping"
            continue
        fi
        ln -s ${item} ${filename}
    done
}

setup_gpg() {
    gpg --keyserver $(dig +short keyserver.ubuntu.com | head -n 1) --recv-keys FD3D7BD0882FE25C1B9B415BF393DA8310B040C1
    echo "enable-ssh-support" > ${HOME}/.gnupg/gpg-agent.conf
}

[[ $(uname -s) != "Darwin" ]] && install_essentials
[[ $(uname -s) == "Darwin" ]] && install_essentials_osx
remove_old_files
configure_neovim
configure_git
configure_tmux
configure_alacritty
create_symlinks
setup_gpg

_success "Setup complete!"
_success "Reload your shell for changes to take place..."

exit 0
