# bat - https://github.com/sharkdp/bat

if ! command -v wt >/dev/null 2>&1; then
    return
fi

eval "$(command wt config shell init zsh)"
