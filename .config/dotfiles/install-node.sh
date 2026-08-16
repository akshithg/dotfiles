#!/usr/bin/env bash
set -euo pipefail

# fnm + Node + pnpm

if ! command -v fnm >/dev/null; then
  /opt/homebrew/bin/brew install fnm
fi

# fnm env needs an interactive-ish shell to set PATH for the install steps.
zsh -c 'eval "$(fnm env)" && fnm install 22 && fnm default 22 && npm install -g pnpm'
