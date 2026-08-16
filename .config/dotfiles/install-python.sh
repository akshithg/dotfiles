#!/usr/bin/env bash
set -euo pipefail

# uv + Python tooling

if ! command -v uv >/dev/null; then
  curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh |
    env INSTALLER_NO_MODIFY_PATH=1 sh
fi

uv tool install ruff
uv tool install ty
uv tool install pip-audit
