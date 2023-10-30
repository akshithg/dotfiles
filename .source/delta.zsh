# delta - https://github.com/dandavison/delta

if ! command -v delta >/dev/null 2>&1; then
    return
fi

# check if $_THEME is set
if [ -z ${_THEME} ]; then
    return
fi

config_file=${XDG_CONFIG_HOME:-$HOME/.config}/delta/delta.gitconfig
dark_theme='syntax-theme = Catppuccin-mocha'
light_theme='syntax-theme = Catppuccin-latte'

source ${HOME}/.source/switch_theme.zsh
switch_theme >/dev/null 2>&1
