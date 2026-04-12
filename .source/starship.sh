# starship - https://starship.rs/

if ! command -v starship >/dev/null 2>&1; then
    return
fi

export STARSHIP_CONFIG="${XDG_STATE_HOME:-$HOME/.local/state}/starship.toml"
eval "$(starship init zsh)"
