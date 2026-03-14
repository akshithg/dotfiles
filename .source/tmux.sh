# tmux

if ! command -v tmux >/dev/null 2>&1; then
    return
fi

alias t="tmux new -A -s"
alias tl="tmux list-sessions"
alias tn="tmux new-session"

switch_theme \
    "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf" \
    "@catppuccin_flavor 'mocha'" \
    "@catppuccin_flavor 'latte'"
