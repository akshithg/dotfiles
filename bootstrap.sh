#!/bin/sh
# Bootstrap dotfiles into $HOME via bare git repo.
# Usage: curl -fsSL https://raw.githubusercontent.com/akshithg/dotfiles/main/bootstrap.sh | sh
set -eu

REPO="${DOTFILES_REPO:-https://github.com/akshithg/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.config-backup}"

dotgit() {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# Already bootstrapped? Just pull.
if [ -d "$DOTFILES_DIR" ]; then
    echo "==> Dotfiles already bootstrapped, pulling latest..."
    dotgit fetch origin main:refs/remotes/origin/main
    dotgit reset --hard origin/main
    echo "Done."
    exit 0
fi

# Required tools
for cmd in git curl; do
    command -v "$cmd" >/dev/null || { echo "Error: $cmd is required" >&2; exit 1; }
done

echo "==> Cloning $REPO to $DOTFILES_DIR..."
git clone --bare "$REPO" "$DOTFILES_DIR"

mkdir -p "$HOME/.config" "$HOME/.local/share" "$HOME/.cache" "$HOME/.local/state" "$HOME/.local/bin" "$BACKUP_DIR"

echo "==> Backing up conflicting files to $BACKUP_DIR..."
dotgit checkout 2>&1 | grep -E "^\s" | awk '{print $1}' | while read -r f; do
    mkdir -p "$BACKUP_DIR/$(dirname "$f")"
    mv "$HOME/$f" "$BACKUP_DIR/$f" 2>/dev/null || true
done

echo "==> Checking out dotfiles..."
dotgit checkout
dotgit config --local status.showUntrackedFiles no

# Install tmux plugin manager (silent if already installed or no tmux)
if command -v tmux >/dev/null; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
fi

echo ""
echo "==> Done. Restart your shell or run: exec zsh"
