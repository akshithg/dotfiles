# starship - https://starship.rs/

if ! command -v starship >/dev/null 2>&1; then
    return
fi

eval "$(starship init zsh)"

switch_theme \
    "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml" \
    "palette = 'catppuccin_mocha'" \
    "palette = 'catppuccin_latte'"
