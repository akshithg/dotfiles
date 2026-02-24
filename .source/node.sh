# fnm (Fast Node Manager, installed via Homebrew)
# This sets up:
#   - Dynamic PATH for current Node version
#   - Auto-version switching on directory change (--use-on-cd)
#   - Support for .node-version and .nvmrc files
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell=zsh)"
fi

# pnpm
if command -v pnpm >/dev/null 2>&1; then
    alias npm="pnpm"
fi
