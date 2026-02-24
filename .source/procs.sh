# procs - https://github.com/dalance/procs

if ! command -v procs >/dev/null 2>&1; then
    return
fi

alias ps="procs"
alias pst="procs --tree"
