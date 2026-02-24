# delta - https://github.com/dandavison/delta

if ! command -v delta >/dev/null 2>&1; then
    return
fi

config_file="${XDG_CONFIG_HOME:-$HOME/.config}/delta/delta.gitconfig"
dark_theme='syntax-theme = Catppuccin Mocha'
light_theme='syntax-theme = Catppuccin Latte'

switch_theme >/dev/null 2>&1
