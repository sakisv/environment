#!/usr/bin/env bash

COLOR_DEBUG='\033[1;33m'
COLOR_INFO='\033[1;34m'
COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_RESET='\033[0m'
PREFIX="----->  "

CURRENT_DIR=$(pwd)
DOTFILES_DIR=${CURRENT_DIR}/dotfiles

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
    osx_essentials=(
        "--cask aws-vault"
        "bash"
        "bash_completion"
        "coreutils"
        "curl"
        "direnv"
        "findutils"
        "fzf"
        "gnupg"
        "jq"
        "neovim"
        "openssh"
        "pass"
        "pinentry-mac"
        "pre-commit"
        "pwgen"
        "ripgrep"
        "ruff"
        "tfenv"
        "tmux"
        "tree"
        "wget"
        "ykman"
    )


    if [[ ! $(which brew) ]]; then
        _error "brew is not installed. Exiting..."
        exit 1
    fi

    for item in "${osx_essentials[@]}"; do
        _info "Installing ${item}"
        brew install ${item} > /dev/null
    done

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

create_config_symlinks() {
    _info "Creating config symlinks..."

    # use the gnu version of cp, installed by coreutils
    # Arguments:
    #
    # -r : recursive
    # -s : symbolic link
    # -v : verbose
    # -i : interactive (ask if file exists)
    # -b : backup
    # -S .bak : set the backup suffix
    #
    gcp -rsvib -S .bak ${CURRENT_DIR}/config/* ${HOME}/.config/

    _done
}

configure_neovim() {
    NEOVIM_CONFIG_DIR="${HOME}/.config/nvim"
    NEOVIM_PLUG_VERSION=0.10.0
    NEOVIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/${NEOVIM_PLUG_VERSION}/plug.vim"

    _info "Downloading vim-plug ${NEOVIM_PLUG_VERSION}"
    _download ${NEOVIM_PLUG_URL} ${HOME}/.local/share/nvim/site/autoload/plug.vim
    _done

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

create_dotfile_symlinks() {
    _info "Creating symlinks..."
    for item in "${DOTFILES_DIR}"/*; do
        # Skip over dirs
        [[ -d "${item}" ]] && continue

        filename=${HOME}/.$(basename ${item})
        if [[ -f ${filename} ]]; then
            _info "${filename} exists, skipping"
            continue
        fi
        _info "Symlinking ${filename} to ${item}"
        ln -s ${item} ${filename}
    done
}

setup_gpg() {
    local key_id="FD3D7BD0882FE25C1B9B415BF393DA8310B040C1"
    gpg --keyserver $(dig +short keyserver.ubuntu.com | head -n 1) --recv-keys ${key_id}
    echo "enable-ssh-support" > ${HOME}/.gnupg/gpg-agent.conf
    echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ${HOME}/.gnupg/gpg-agent.conf

    echo "standard-resolver" > ${HOME}/.gnupg/dirmngr.conf

    _success "Updated gpg configuration \nTrust the key by running:\n\tgpg --edit-key ${key_id}\nand then pass 'trust -> 5 -> y -> quit'"

}

install_essentials_osx
remove_old_files
create_config_symlinks
configure_neovim
configure_git
configure_tmux
create_dotfile_symlinks
setup_gpg

_success "Setup complete!"
_success "Reload your shell for changes to take place..."

exit 0
