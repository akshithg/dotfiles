#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if (($# == 0)); then
  echo 'usage: install-tools.sh <cargo|uv|pnpm> [...]' >&2
  exit 2
fi

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
export PATH="$PNPM_HOME/bin:$PNPM_HOME:$CARGO_HOME/bin:$PATH"

for manager in "$@"; do
  case "$manager" in
    cargo | uv | pnpm) ;;
    *)
      echo "install-tools.sh: unknown manager: $manager" >&2
      exit 2
      ;;
  esac
  if ! command -v "$manager" >/dev/null 2>&1; then
    echo "install-tools.sh: $manager is unavailable; run install.sh first." >&2
    exit 1
  fi
done

for manager in "$@"; do
  while IFS= read -r package || [[ -n "$package" ]]; do
    [[ -z "$package" || "$package" == \#* ]] && continue
    case "$manager" in
      cargo) cargo install "$package" ;;
      uv) uv tool install --upgrade "$package" ;;
      pnpm) pnpm add --global "$package" ;;
    esac
  done <"$repo_dir/tools/$manager.txt"
done
