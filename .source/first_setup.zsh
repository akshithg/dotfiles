# functions for first setup

_check_macos() {
    if [ "$(uname)" != "Darwin" ]; then
        echo "Not macOS, not installing Homebrew"
        return
    fi
}

_install_homebrew() {
    _check_macos
    if [ -x "$(command -v brew)" ]; then
        echo "Homebrew is already installed"
        return
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

_install_homebrew_packages() {
    _check_macos
    _install_homebrew
    /opt/homebrew/bin/brew update
    /opt/homebrew/bin/brew install \
        fzf \
        git \
        neovim \
        zsh

    $(/opt/homebrew/bin/brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --xdg
}


# https://github.com/darksonic37/linuxify/blob/master/linuxify
linuxify_formulas=(
    # GNU programs non-existing in macOS
    "watch"
    "wget"
    "wdiff"
    "gdb" intel only
    "autoconf"

    # GNU programs whose BSD counterpart is installed in macOS
    "coreutils"
    "binutils"
    "diffutils"
    "ed"
    "findutils"
    "gawk"
    "gnu-indent"
    "gnu-sed"
    "gnu-tar"
    "gnu-which"
    "grep"
    "gzip"
    "screen"

    # GNU programs existing in macOS which are outdated
    "bash"
    "emacs"
    "gpatch"
    "less"
    "m4"
    "make"
    "nano"
    "bison"

    # BSD programs existing in macOS which are outdated
    "flex"

    # Other common/preferred programs in GNU/Linux distributions
    "libressl"
    "file-formula"
    "git"
    "openssh"
    "perl"
    "python"
    "rsync"
    "unzip"
    "vim"
)

_install_homebrew_linuxify() {
    _check_macos
    _install_homebrew
    # Install all formulas
    for (( i=0; i<${#linuxify_formulas[@]}; i++ )); do
        if brew ls --versions ${linuxify_formulas[i]}; then
            echo "Found Existing ${linuxify_formulas[i]}"
        else
            echo "Installing ${linuxify_formulas[i]}"
            brew install ${linuxify_formulas[i]}
        fi
    done
}

_install_rust() {
    if [ -x "$(command -v rustup)" ]; then
        echo "rustup is already installed"
        return
    fi
    curl https://sh.rustup.rs -sSf | sh
    source ${XDG_DATA_HOME:-$HOME/.local/share}/cargo/env
    rustup update || rustup install stable
}

_install_rust_binaries() {
    _install_rust
    cargo install \
        bat \
        du-dust \
        eza \
        fd-find \
        git-delta \
        procs \
        ripgrep \
        starship \
        vivid
}

_install_apt_packages() {
    sudo apt update
    sudo apt install -y \
        fzf \
        git \
        neovim \
        zsh
}
