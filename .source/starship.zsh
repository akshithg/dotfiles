# starship - https://starship.rs/

if ! command -v starship >/dev/null 2>&1; then
    return
fi

# check if $_THEME is set
if [ -z ${_THEME} ]; then
    return
fi

config_file=${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml
dark_theme="palette = 'catppuccin_mocha'"
light_theme="palette = 'catppuccin_latte'"

source ${HOME}/.source/switch_theme.zsh
switch_theme >/dev/null 2>&1
