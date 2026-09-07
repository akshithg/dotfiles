#!/usr/bin/env bash
set -euo pipefail

config="${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml"

# The binding table intentionally uses one TOML assignment per line.
awk '
  /^\[mode\.main\.binding\]$/ { in_bindings = 1; next }
  /^\[/ && in_bindings { exit }
  in_bindings && /^[[:alnum:]-]+[[:space:]]*=/ {
    separator = index($0, " = ")
    key = substr($0, 1, separator - 1)
    action = substr($0, separator + 3)

    sub(/^cmd-alt-ctrl-shift-/, "Super+Shift+", key)
    sub(/^cmd-alt-ctrl-/, "Super+", key)
    gsub(/-/, "+", key)
    printf "%-24s %s\n", key, action
  }
' "$config" | fzf \
  --no-sort \
  --layout=reverse \
  --prompt="search: " \
  --header="AeroSpace keybindings (Esc to close)" \
  --header-first
