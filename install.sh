#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
  cat <<'EOF'
Usage: ./install.sh <group> [group ...]

Groups:
  core      Install all formulas, link dotfiles, and set up Rust and Node.js
  cask      Install Brewfile.cask
  defaults  Apply macOS defaults and restart affected applications

Run without arguments to show this help without changing anything.
EOF
}

if (($# == 0)); then
  usage
  exit 0
fi

groups=("$@")
needs_brew=false
validated_groups=()
for group in "${groups[@]}"; do
  case "$group" in
    core | cask) needs_brew=true ;;
    defaults) ;;
    -h | --help)
      if ((${#groups[@]} == 1)); then
        usage
        exit 0
      fi
      echo "--help cannot be combined with groups." >&2
      exit 2
      ;;
    *)
      echo "Unknown group: $group" >&2
      usage >&2
      exit 2
      ;;
  esac
  for previous_group in "${validated_groups[@]}"; do
    if [[ $previous_group == "$group" ]]; then
      echo "Duplicate group: $group" >&2
      exit 2
    fi
  done
  validated_groups+=("$group")
done

if [[ $(uname -s) != Darwin ]]; then
  echo "install.sh supports macOS only." >&2
  exit 1
fi

if [[ $needs_brew == true ]] && ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh" >&2
  exit 1
fi

export HOMEBREW_NO_ANALYTICS=1

install_core() {
  brew bundle --file="$repo_dir/Brewfile" --no-upgrade

  mkdir -p \
    "$HOME/.cache" \
    "$HOME/.config" \
    "$HOME/.local/bin" \
    "$HOME/.local/share" \
    "$HOME/.local/state"

  if [[ ! -e "$HOME/.ssh" ]]; then
    mkdir -m 700 "$HOME/.ssh"
  fi

  stow --dir="$repo_dir" --target="$HOME" --restow --ignore='\.DS_Store$' home
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

  echo "Dotfiles installed. Start a new shell to load them."
}

for group in "${groups[@]}"; do
  case "$group" in
    core) install_core ;;
    cask) brew bundle --file="$repo_dir/Brewfile.cask" --no-upgrade ;;
    defaults) "$repo_dir/home/.config/macos/defaults.sh" ;;
  esac
done
