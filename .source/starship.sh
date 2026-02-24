# starship - https://starship.rs/

if ! command -v starship >/dev/null 2>&1; then
    return
fi

eval "$(starship init zsh)"

config_file="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
dark_theme="palette = 'catppuccin_mocha'"
light_theme="palette = 'catppuccin_latte'"

switch_theme >/dev/null 2>&1
