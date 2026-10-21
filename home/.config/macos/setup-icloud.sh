#!/usr/bin/env bash
set -euo pipefail

# Link ~/Documents to iCloud Drive
# This replaces the local Documents folder with a symlink to iCloud

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: Not macOS" >&2
  exit 1
fi

icloud_docs="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"

if [[ ! -d "$icloud_docs" ]]; then
  echo "Error: iCloud Documents folder not found."
  echo "Enable iCloud Drive in System Settings first."
  exit 1
fi

if [[ -L "$HOME/Documents" ]]; then
  current_target="$(readlink "$HOME/Documents")"
  if [[ "$current_target" == "$icloud_docs" ]]; then
    echo "Documents already symlinked to iCloud."
    exit 0
  else
    echo "Documents is symlinked to: $current_target"
    echo "Remove it manually before proceeding."
    exit 1
  fi
fi

if [[ -d "$HOME/Documents" ]]; then
  backup_dir="$icloud_docs/Documents-backup-$(date +%Y%m%d-%H%M%S)"
  echo "Moving existing Documents to $backup_dir..."

  mkdir -p "$backup_dir"
  mv "$HOME/Documents"/* "$backup_dir/" 2>/dev/null || true
  mv "$HOME/Documents"/.[!.]* "$backup_dir/" 2>/dev/null || true
  rmdir "$HOME/Documents"
fi

ln -s "$icloud_docs" "$HOME/Documents"
echo "Documents linked to iCloud."
