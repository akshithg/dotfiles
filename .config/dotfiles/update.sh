#!/usr/bin/env bash
set -euo pipefail

# Upgrade all tool managers

brew=/opt/homebrew/bin/brew

"$brew" update
"$brew" upgrade

rustup update
cargo install prek worktrunk cargo-deny cargo-careful

uv tool upgrade --all

if command -v pnpm >/dev/null; then
  pnpm update -g
fi

echo "All tools updated."
