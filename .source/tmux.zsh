#!/bin/sh

if ! command -v tmux >/dev/null 2>&1; then
    return
fi

alias  t="tmux new -A -s"
alias tl="tmux list-sessions"
alias ta="tmux attach -t"
alias tn="tmux new-session"

# check if $_THEME is set
if [ -z ${_THEME} ]; then
    return
fi

config_file=${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf
dark_theme="@catppuccin_flavour 'mocha'"
light_theme="@catppuccin_flavour 'latte'"

source ${HOME}/.source/switch_theme.zsh
switch_theme >/dev/null 2>&1
