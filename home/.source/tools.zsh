# Interactive tool initialization

unset BAT_THEME BAT_THEME_LIGHT BAT_THEME_DARK

if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid --color-mode 8-bit generate ansi)"
fi

export FZF_DEFAULT_OPTS="--height 60%
  --border rounded
  --layout reverse
  --color 16
  --prompt '∷ '
  --pointer ▶
  --marker ⇒"

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"

  if command -v fd >/dev/null 2>&1; then
    _fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1"; }
    _fzf_compgen_dir() { fd --type d --hidden --follow --exclude .git . "$1"; }
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  elif command -v rg >/dev/null 2>&1; then
    _fzf_compgen_path() { rg --files --hidden --follow --glob '!.git/*' "$1"; }
    _fzf_compgen_dir() { find "$1" -type d -not -path '*/.git/*'; }
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  fi

  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND:-}"
  export FZF_COMPLETION_DIR_COMMANDS='cd pushd rmdir ls eza'
  export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'"

  if command -v pbcopy >/dev/null 2>&1; then
    _fzf_clip='pbcopy'
  elif command -v wl-copy >/dev/null 2>&1; then
    _fzf_clip='wl-copy'
  elif command -v xclip >/dev/null 2>&1; then
    _fzf_clip='xclip -selection clipboard'
  fi
  if [[ -n "${_fzf_clip:-}" ]]; then
    FZF_CTRL_R_OPTS+=" --bind 'ctrl-y:execute-silent(echo -n {2..} | ${_fzf_clip})+abort'"
    FZF_CTRL_R_OPTS+=" --header 'Press CTRL-Y to copy command into clipboard'"
    export FZF_CTRL_R_OPTS
    unset _fzf_clip
  fi
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell=zsh)"
fi

if command -v uv >/dev/null 2>&1; then
  export UV_PYTHON_PREFERENCE='only-managed'
  export UV_PYTHON='3'
  eval "$(uv --generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v wt >/dev/null 2>&1 && eval "$(command wt config shell init zsh)"

export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship.toml"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
