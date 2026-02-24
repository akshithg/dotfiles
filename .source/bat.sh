# bat - https://github.com/sharkdp/bat

if ! command -v bat >/dev/null 2>&1; then
    return
fi

alias cat="bat"
