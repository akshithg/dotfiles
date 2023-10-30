# eza - https://github.com/eza-community/eza

if ! command -v eza >/dev/null 2>&1; then
    return
fi

alias ls="eza"
alias l="ls"
alias la="ls -a"
alias lf="ls -F"
alias lh="ls -lh"
alias ll="ls -l"
alias lll="ls -lhFa"
alias sl="ls"
