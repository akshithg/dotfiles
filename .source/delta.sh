# delta - https://github.com/dandavison/delta

if ! command -v delta >/dev/null 2>&1; then
    return
fi

switch_theme \
    "${XDG_CONFIG_HOME:-$HOME/.config}/delta/delta.gitconfig" \
    'syntax-theme = Catppuccin Mocha' \
    'syntax-theme = Catppuccin Latte'
