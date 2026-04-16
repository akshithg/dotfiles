# shellcheck shell=bash
# tmux

if ! command -v tmux >/dev/null 2>&1; then
    return
fi

alias t="tmux new -A -s"
alias tl="tmux list-sessions"
alias tn="tmux new-session"

# Tmux Dev Layout — nvim (left 70%) + AI (right 30%) + terminal (bottom 15%)
# Usage: tdl <c|claude|codex|command> [<second_ai>]
tdl() {
    [[ -z $1 ]] && { echo "Usage: tdl <c|claude|codex|command> [<second_ai>]"; return 1; }
    [[ -z $TMUX ]] && { echo "You must be in tmux to use tdl."; return 1; }

    local current_dir="${PWD}"
    local editor_pane ai_pane ai2_pane
    local ai="$1"
    local ai2="$2"

    editor_pane="$TMUX_PANE"
    tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

    # Bottom terminal strip (15%)
    tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

    # AI pane on right (30% of editor area)
    ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

    # Optional second AI pane below the first
    if [[ -n $ai2 ]]; then
        ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
        tmux send-keys -t "$ai2_pane" "$ai2" C-m
    fi

    tmux send-keys -t "$ai_pane" "$ai" C-m
    tmux send-keys -t "$editor_pane" "${EDITOR:-nvim} ." C-m
    tmux select-pane -t "$editor_pane"
}

# Multi-project Dev Layout — one tdl window per subdirectory
# Usage: tdlm <c|claude|codex|command> [<second_ai>]
tdlm() {
    [[ -z $1 ]] && { echo "Usage: tdlm <command> [<second_ai>]"; return 1; }
    [[ -z $TMUX ]] && { echo "You must be in tmux to use tdlm."; return 1; }

    local ai="$1"
    local ai2="$2"
    local base_dir="$PWD"
    local first=true

    tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

    for dir in "$base_dir"/*/; do
        [[ -d $dir ]] || continue
        local dirpath="${dir%/}"

        if $first; then
            tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
            first=false
        else
            local pane_id
            pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
            tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
        fi
    done
}

# Tmux Swarm Layout — N panes each running the same command
# Usage: tsl <pane_count> <command>
tsl() {
    [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
    [[ -z $TMUX ]] && { echo "You must be in tmux to use tsl."; return 1; }

    local count="$1"
    local cmd="$2"
    local current_dir="${PWD}"
    local -a panes

    tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
    panes+=("$TMUX_PANE")

    while (( ${#panes[@]} < count )); do
        local new_pane
        local split_target="${panes[-1]}"
        new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
        panes+=("$new_pane")
        tmux select-layout -t "${panes[1]}" tiled
    done

    for pane in "${panes[@]}"; do
        tmux send-keys -t "$pane" "$cmd" C-m
    done

    tmux select-pane -t "${panes[1]}"
}
