# zoxide - https://github.com/ajeetdsouza/zoxide

if ! command -v zoxide >/dev/null 2>&1; then
    return
fi

eval "$(zoxide init zsh)"

alias cd="z"
alias cdi="zi"
