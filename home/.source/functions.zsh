# Shell functions

lspath() {
  print -r -- "$PATH" | tr ':' '\n'
}

appendtopath() {
  [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && export PATH="$PATH:$1"
}

prependtopath() {
  [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

claude-local() {
  ANTHROPIC_BASE_URL=http://localhost:1234 \
    ANTHROPIC_AUTH_TOKEN=lmstudio \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    command claude "$@"
}

each() {
  if (( $# == 0 )); then
    print -u2 'usage: each <command> [args...]'
    return 1
  fi

  local dir
  local -a failed
  for dir in */; do
    [[ -d "$dir/.git" ]] || continue
    print -P "%F{blue}${dir%/}%f"
    (cd "$dir" && "$@") || failed+=("${dir%/}")
  done

  if (( ${#failed[@]} )); then
    print -u2 -P "%F{red}failed:%f ${failed[*]}"
    return 1
  fi
}

fdbig() {
  fd -t f "$@" -x du -h {} | sort -rh | head -20
}

fdrm() {
  fd "$@" -x rm -i {}
}

fdv() {
  local file
  file=$(fd "$@" | fzf --preview 'bat --color=always {}')
  [[ -n "$file" ]] && "$EDITOR" "$file"
}

rgv() {
  local pattern=${1:?usage: rgv <pattern> [rg options]}
  shift
  local file
  file=$(rg -l -- "$pattern" "$@" | fzf --preview "rg --color=always -- ${(q)pattern} {}")
  [[ -n "$file" ]] && "$EDITOR" "+/$pattern" "$file"
}

rgtop() {
  rg -c "$@" | sort -t: -k2 -nr | head -20
}

y() {
  local tmp cwd status
  tmp=$(mktemp -t yazi-cwd.XXXXXX) || return
  yazi "$@" --cwd-file="$tmp"
  status=$?
  if cwd=$(command cat -- "$tmp") && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd" || status=$?
  fi
  rm -f -- "$tmp"
  return "$status"
}

wtgo() {
  local path
  path=$(wt list | grep -F -- "$1" | awk 'NR == 1 {print $1}')
  [[ -n "$path" ]] || return 1
  builtin cd -- "$path"
}

tdl() {
  [[ -n "$1" ]] || { print -u2 'usage: tdl <command> [second-command]'; return 1; }
  [[ -n "$TMUX" ]] || { print -u2 'tdl must run inside tmux'; return 1; }

  local current_dir=$PWD editor_pane=$TMUX_PANE ai_pane ai2_pane
  tmux rename-window -t "$editor_pane" "${current_dir:t}"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  if [[ -n "$2" ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" -l -- "$2"
    tmux send-keys -t "$ai2_pane" Enter
  fi

  tmux send-keys -t "$ai_pane" -l -- "$1"
  tmux send-keys -t "$ai_pane" Enter
  tmux send-keys -t "$editor_pane" -l -- "${EDITOR:-nvim} ."
  tmux send-keys -t "$editor_pane" Enter
  tmux select-pane -t "$editor_pane"
}

tdlm() {
  [[ -n "$1" ]] || { print -u2 'usage: tdlm <command> [second-command]'; return 1; }
  [[ -n "$TMUX" ]] || { print -u2 'tdlm must run inside tmux'; return 1; }

  local dir dirpath pane_id command_line session_name
  local base_dir=$PWD first=1
  printf -v command_line 'tdl %q %q' "$1" "$2"
  session_name=${base_dir:t}
  session_name=${session_name//[.:]/--}
  tmux rename-session "$session_name"

  for dir in "$base_dir"/*/; do
    [[ -d "$dir" ]] || continue
    dirpath=${dir%/}
    if (( first )); then
      pane_id=$TMUX_PANE
      first=0
    else
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
    fi
    tmux send-keys -t "$pane_id" -l -- "$command_line"
    tmux send-keys -t "$pane_id" Enter
  done
}

tsl() {
  [[ "$1" == <1-> && -n "$2" ]] || { print -u2 'usage: tsl <pane-count> <command>'; return 1; }
  [[ -n "$TMUX" ]] || { print -u2 'tsl must run inside tmux'; return 1; }

  local count=$1 command=$2 current_dir=$PWD new_pane split_target
  local -a panes=("$TMUX_PANE")
  tmux rename-window -t "$TMUX_PANE" "${current_dir:t}"

  while (( ${#panes[@]} < count )); do
    split_target=${panes[-1]}
    new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[1]}" tiled
  done

  local pane
  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" -l -- "$command"
    tmux send-keys -t "$pane" Enter
  done
  tmux select-pane -t "${panes[1]}"
}

if [[ -d "$HOME/workspace/trailofbits/hercules" ]]; then
  ghidra() {
    (cd "$HOME/workspace/trailofbits/hercules" && ./launch-ghidra.sh "$@")
  }

  ghidra-mcp() {
    nc -z localhost 31337 2>/dev/null && {
      print '[+] hercules mcp up at http://localhost:31337/mcp'
      return
    }
    print -u2 '[!] hercules mcp unreachable; start Ghidra with ghidra'
    return 1
  }
fi
