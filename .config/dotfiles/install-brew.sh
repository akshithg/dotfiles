#!/usr/bin/env bash
set -euo pipefail

# Homebrew + CLI tools

brew=/opt/homebrew/bin/brew

if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

packages=(
  git
  git-delta

  neovim

  bat
  dust
  eza
  fd
  fzf
  jq
  procs
  ripgrep
  vivid
  zoxide

  btop
  lazydocker
  lazygit
  yazi

  actionlint
  shellcheck
  shfmt
  zizmor
  ast-grep

  tldr
  gum

  colima
  docker
  macos-trash
)

"$brew" update
"$brew" install "${packages[@]}"
