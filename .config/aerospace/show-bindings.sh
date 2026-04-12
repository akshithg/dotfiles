#!/bin/zsh
set -euo pipefail

# Float this window once it's registered by AeroSpace
(sleep 0.3 && aerospace layout floating) &

config="${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml"

uv run python3 -c "
import tomllib, sys
from pathlib import Path

config = tomllib.loads(Path(sys.argv[1]).read_text())

labels = {
    'open -a Ghostty': 'open terminal',
    'close': 'close window',
    'fullscreen': 'toggle fullscreen',
    'layout floating tiling': 'toggle floating',
    'layout tiles horizontal vertical': 'toggle split',
    'mode resize': 'enter resize mode',
    'reload-config': 'reload config',
    'balance-sizes': 'balance sizes',
    'workspace-back-and-forth': 'last workspace',
    'mode main': 'exit mode',
}

def fmt_key(k):
    k = k.replace('cmd-alt-ctrl-shift', 'Super+Shift')
    k = k.replace('cmd-alt-ctrl', 'Super')
    return k.replace('-', '+')

def fmt_action(a):
    if isinstance(a, list):
        a = ', '.join(a)
    for prefix in ['exec-and-forget ']:
        a = a.replace(prefix, '')
    if 'osascript' in a:
        return 'spotlight'
    if 'show-bindings' in a:
        return 'show keybindings'
    if 'move-node-to-workspace' in a and 'workspace' in a:
        ws = a.split('move-node-to-workspace ')[1].split(',')[0].strip()
        return f'move to workspace {ws} (follow)'
    return labels.get(a, a)

for mode_name, mode in config.get('mode', {}).items():
    for key, action in mode.get('binding', {}).items():
        k = fmt_key(key)
        if mode_name != 'main':
            k = f'[{mode_name}] {k}'
        print(f'{k:<28}  {fmt_action(action)}')
" "$config" | fzf --no-sort --layout=reverse \
    --prompt="search: " \
    --header="AeroSpace Keybindings  (Esc to close)" \
    --header-first
