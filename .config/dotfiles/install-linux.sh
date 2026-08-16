#!/usr/bin/env bash
set -euo pipefail

# CLI tools via the host's package manager

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "Error: Not Linux" >&2
  exit 1
fi

common=(
  zsh git curl ca-certificates
  neovim tmux
  ripgrep fzf bat eza zoxide
  jq btop
)

if command -v apt-get >/dev/null; then
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    "${common[@]}" fd-find shellcheck

  # Debian ships these under different names; link them to the usual ones.
  if [[ -e /usr/bin/fdfind && ! -e /usr/local/bin/fd ]]; then
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
  fi
  if [[ -e /usr/bin/batcat && ! -e /usr/local/bin/bat ]]; then
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
  fi
elif command -v dnf >/dev/null; then
  sudo dnf install -y "${common[@]}" fd-find ShellCheck lazygit
elif command -v pacman >/dev/null; then
  sudo pacman -Sy --noconfirm --needed \
    "${common[@]}" fd shellcheck starship git-delta yazi lazygit lazydocker
else
  echo "Error: no supported package manager (apt/dnf/pacman) found" >&2
  exit 1
fi

if ! command -v starship >/dev/null; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

if ! command -v delta >/dev/null; then
  echo "Note: install git-delta separately (not in apt repos)"
fi
