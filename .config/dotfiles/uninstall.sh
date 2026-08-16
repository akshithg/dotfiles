#!/usr/bin/env bash
set -euo pipefail

# Remove dotfiles from $HOME and restore backups

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.config-backup}"

dotgit() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# git scopes pathspecs to the cwd, and this is often run from a clone inside
# $HOME, where ls-tree would otherwise list nothing.
cd "$HOME" || exit 1

echo "This will remove dotfiles and restore backups."
echo "Press Ctrl-C to abort, Enter to continue."
# No tty (piped, CI) reads as EOF; refuse rather than delete unconfirmed.
read -r _ || {
  echo "Aborted: no confirmation on stdin." >&2
  exit 1
}

# Repo-only paths are never checked out, so a file of that name in $HOME is the
# user's, not ours. Read the list off the repo's own sparse-checkout config
# rather than keeping a second copy of it here.
repo_only=$(sed -n 's|^!/||p' "$DOTFILES_DIR/info/sparse-checkout" 2>/dev/null || true)

is_repo_only() {
  local e
  for e in $repo_only; do
    [[ "$1" == "$e" || "$1" == "$e"/* ]] && return 0
  done
  return 1
}

dotgit ls-tree -r HEAD --name-only | while read -r f; do
  is_repo_only "$f" && continue
  rm -f "$HOME/$f"
done

rm -rf "$DOTFILES_DIR"

if [[ -d "$BACKUP_DIR" ]]; then
  echo "Restoring backups from $BACKUP_DIR..."
  cp -r "$BACKUP_DIR/." "$HOME/"
  echo "Backups restored. You can remove $BACKUP_DIR manually."
fi

echo "Dotfiles removed. Restart your shell."
