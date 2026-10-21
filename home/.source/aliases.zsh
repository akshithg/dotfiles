# Shell aliases

alias rl='source "$ZDOTDIR/.zshrc"'
alias c='clear'
alias q='exit'
alias dotgit='git -C "$HOME/.dotfiles"'
alias d='dotgit'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias l='eza'
  alias la='eza -a'
  alias ll='eza -l --git'
  alias lll='eza -la --git'
  alias lt='eza -T --level=2'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias l='ls'
  alias la='ls -a'
  alias ll='ls -l'
  alias lll='ls -lhFa'
else
  alias ls='ls --color=auto'
  alias l='ls'
  alias la='ls -a'
  alias ll='ls -l'
  alias lll='ls -lhFa'
fi
alias sl='ls'

command -v bat >/dev/null 2>&1 && alias cat='bat'
command -v btop >/dev/null 2>&1 && alias top='btop'
command -v dust >/dev/null 2>&1 && alias du='dust'
command -v glow >/dev/null 2>&1 && alias readme='glow' md='glow'
command -v lazydocker >/dev/null 2>&1 && alias lzd='lazydocker'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
command -v nvim >/dev/null 2>&1 && alias vim='nvim' vi='nvim'
command -v pnpm >/dev/null 2>&1 && alias npm='pnpm'
command -v procs >/dev/null 2>&1 && alias ps='procs' pst='procs --tree'

if command -v tmux >/dev/null 2>&1; then
  alias t='tmux new -A -s'
  alias tl='tmux list-sessions'
  alias tn='tmux new-session'
fi

if command -v wt >/dev/null 2>&1; then
  alias wta='wt switch --create'
  alias wts='wt switch'
  alias wtl='wt list'
  alias wtr='wt remove'
  alias wtp='wt prune'
fi

if command -v zoxide >/dev/null 2>&1; then
  alias cd='z'
  alias cdi='zi'
fi

if command -v fd >/dev/null 2>&1; then
  alias fda='fd --hidden --no-ignore'
  alias fdd='fd -t d'
  alias fdf='fd -t f'
  alias fdpy='fd -e py'
  alias fdjs='fd -e js'
  alias fdrs='fd -e rs'
  alias fdnew='fd --changed-within 1d'
  alias fdweek='fd --changed-within 7d'
fi

if command -v rg >/dev/null 2>&1; then
  alias rgi='rg -i'
  alias rga='rg --hidden --no-ignore'
  alias rgf='rg -l'
  alias todos="rg -i 'TODO|FIXME|HACK|XXX'"
  alias rgpy='rg -t py'
  alias rgjs='rg -t js'
  alias rgrs='rg -t rust'
  alias rggo='rg -t go'
  alias rgc='rg -C 5'
  alias rgl='rg -F'
  alias rgcount='rg -c --sort-files'
fi

alias e='each'
