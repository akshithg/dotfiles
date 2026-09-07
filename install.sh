#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [[ $(uname -s) != Darwin ]]; then
  echo "install.sh supports macOS only." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh" >&2
  exit 1
fi

export HOMEBREW_NO_ANALYTICS=1
brew bundle --file="$repo_dir/Brewfile" --no-upgrade

mkdir -p \
  "$HOME/.cache" \
  "$HOME/.config" \
  "$HOME/.local/bin" \
  "$HOME/.local/share" \
  "$HOME/.local/state"

stow --dir="$repo_dir" --target="$HOME" --restow home
bat cache --build

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
rustup_prefix=$(brew --prefix rustup)
export PATH="$CARGO_HOME/bin:$rustup_prefix/bin:$PATH"
rustup default stable

eval "$(fnm env --shell bash)"
fnm install 22
fnm default 22

uv tool install --upgrade ruff
uv tool install --upgrade ty
uv tool install --upgrade pip-audit

echo "Dotfiles installed. Start a new shell to load them."
