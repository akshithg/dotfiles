# op - 1Password CLI

command -v op >/dev/null 2>&1 || return

OP_ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/op/env.tpl"
[ -f "$OP_ENV_FILE" ] || return

alias claude='op run --env-file="$OP_ENV_FILE" -- claude'
alias dropkit='op run --env-file="$OP_ENV_FILE" -- dropkit'
