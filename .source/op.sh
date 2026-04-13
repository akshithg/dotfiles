# op - 1Password CLI
# `op run` doesn't forward the TTY to TUI subprocesses (TUIs detect no TTY and
# fall back to non-interactive mode). Use `op inject` in a subshell instead —
# subshells inherit file descriptors, so the TTY survives.

command -v op >/dev/null 2>&1 || return

OP_ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/op/env.tpl"
[ -f "$OP_ENV_FILE" ] || return

# Drop any stale aliases from previous shell state
unalias claude 2>/dev/null

# `function NAME { ... }` form bypasses alias expansion on the name at parse time
function claude {
    (
        set -a
        eval "$(op inject -i "$OP_ENV_FILE" 2>/dev/null)"
        set +a
        command claude "$@"
    )
}
