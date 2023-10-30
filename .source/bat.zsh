# bat - https://github.com/sharkdp/bat

if ! command -v bat >/dev/null 2>&1; then
    return
fi

alias cat="bat"

# check if $_THEME is set
if [ -z ${_THEME} ]; then
    return
fi

config_file=${XDG_CONFIG_HOME:-$HOME/.config}/bat/config
dark_theme='--theme="Catppuccin-mocha"'
light_theme='--theme="Catppuccin-latte"'

source ${HOME}/.source/switch_theme.zsh
switch_theme >/dev/null 2>&1
