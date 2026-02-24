# tmux

if ! command -v tmux >/dev/null 2>&1; then
    return
fi

alias t="tmux new -A -s"
alias tl="tmux list-sessions"
alias tn="tmux new-session"

config_file="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
dark_theme="@catppuccin_flavor 'mocha'"
light_theme="@catppuccin_flavor 'latte'"

switch_theme >/dev/null 2>&1
