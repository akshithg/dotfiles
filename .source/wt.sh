# wt - git worktree manager

if ! command -v wt >/dev/null 2>&1; then
    return
fi

eval "$(command wt config shell init zsh)"


alias wta='wt switch --create'
alias wts='wt switch'
alias wtl='wt list'
alias wtr='wt remove'
alias wtp='wt prune'

# cd into a worktree by branch name
wtgo() {
  cd "$(wt list | grep "$1" | awk '{print $1}')"
}

