#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

shellcheck \
  "$repo_dir/install.sh" \
  "$repo_dir/check.sh" \
  "$repo_dir/home/.config/aerospace/show-bindings.sh" \
  "$repo_dir/home/.config/macos/defaults.sh" \
  "$repo_dir/home/.config/macos/setup-icloud.sh"

shfmt -d -i 2 -ci \
  "$repo_dir/install.sh" \
  "$repo_dir/check.sh" \
  "$repo_dir/home/.config/aerospace/show-bindings.sh" \
  "$repo_dir/home/.config/macos/defaults.sh" \
  "$repo_dir/home/.config/macos/setup-icloud.sh"

zsh -n \
  "$repo_dir/home/.zshenv" \
  "$repo_dir/home/.config/zsh/.zshenv" \
  "$repo_dir/home/.config/zsh/.zprofile" \
  "$repo_dir/home/.config/zsh/.zshrc" \
  "$repo_dir/home/.source/aliases.zsh" \
  "$repo_dir/home/.source/functions.zsh" \
  "$repo_dir/home/.source/secrets.zsh" \
  "$repo_dir/home/.source/tools.zsh"

jq empty "$repo_dir/home/.config/karabiner/karabiner.json"

if python3 -c 'import tomllib' >/dev/null 2>&1; then
  python3 - "$repo_dir" <<'PY'
import pathlib
import sys
import tomllib

root = pathlib.Path(sys.argv[1])
for path in (
    root / "home/.config/aerospace/aerospace.toml",
    root / "home/.config/herdr/config.toml",
    root / "home/.config/starship.toml",
    root / "home/.codex-red/red.config.toml",
):
    tomllib.loads(path.read_text())
PY
fi

git -C "$repo_dir" diff --check
echo "Checks passed."
