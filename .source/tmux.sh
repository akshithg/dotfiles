# tmux

if ! command -v tmux >/dev/null 2>&1; then
    return
fi

alias t="tmux new -A -s"
alias tl="tmux list-sessions"
alias tn="tmux new-session"
