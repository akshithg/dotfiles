# op - 1Password CLI
# `op run` doesn't forward the TTY to TUI subprocesses (TUIs detect no TTY and
# fall back to non-interactive mode). Use `op inject` in a subshell instead —
# subshells inherit file descriptors, so the TTY survives.

command -v op >/dev/null 2>&1 || return

OP_ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/op/env.tpl"
[ -f "$OP_ENV_FILE" ] || return

# Wrap <cmd> so every invocation runs inside a subshell where env vars from
# OP_ENV_FILE are resolved and exported. Using `function` form bypasses alias
# expansion on the name at parse time.
_op_wrap_cmd() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1 || return
    unalias "$cmd" 2>/dev/null
    eval "function $cmd { (set -a; eval \"\$(op inject -i \"\$OP_ENV_FILE\" 2>/dev/null)\"; set +a; command $cmd \"\$@\") }"
}

_op_wrap_cmd claude
_op_wrap_cmd codex
_op_wrap_cmd s3cmd

# Run any command with the OP_ENV_FILE secrets resolved into its environment.
# The per-command wrappers above only cover direct interactive calls; a script
# (make, ./foo.sh) that shells out to a wrapped tool in a subprocess never sees
# them. `opx <cmd>` injects the env once for the whole process tree, so those
# nested calls inherit the secrets. E.g. `opx make dataset-status`.
opx() { (set -a; eval "$(op inject -i "$OP_ENV_FILE" 2>/dev/null)"; set +a; "$@") }
