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

# git scopes pathspecs to the cwd, and this script is often run from a clone
# inside $HOME. Root every dotgit call at the work tree instead.
cd "$HOME" || exit 1

# Already bootstrapped? Just pull.
if [ -d "$DOTFILES_DIR" ]; then
    echo "==> Dotfiles already bootstrapped, pulling latest..."
    # The reset below is a hard one. Never run it over uncommitted work.
    dirty=$(dotgit status --porcelain -uno)
    if [ -n "$dirty" ]; then
        echo "Error: uncommitted changes in \$HOME would be lost:" >&2
        echo "$dirty" >&2
        echo "Commit, stash, or discard them, then re-run." >&2
        exit 1
    fi
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

# A bare clone configures no fetch refspec, so origin/* would never update and
# `dotgit status` would misreport how far ahead you are.
dotgit config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotgit fetch origin
dotgit branch --set-upstream-to=origin/main main

# Files that describe the repo, not the machine: tracked in git, never checked
# out into $HOME.
REPO_ONLY="README.md CLAUDE.md .dockerignore test"

repo_only() {
    for e in $REPO_ONLY; do
        case "$1" in "$e" | "$e"/*) return 0 ;; esac
    done
    return 1
}

# Leading /* then negations = non-cone sparse-checkout.
echo "==> Excluding repo-only files..."
dotgit config --local core.sparseCheckout true
{
    echo '/*'
    for f in $REPO_ONLY; do echo "!/$f"; done
} > "$DOTFILES_DIR/info/sparse-checkout"

mkdir -p "$HOME/.config" "$HOME/.local/share" "$HOME/.cache" "$HOME/.local/state" "$HOME/.local/bin" "$BACKUP_DIR"

# Move aside anything already in $HOME that we are about to write. This has to
# happen BEFORE any checkout: with sparse-checkout on, git downgrades an
# overwrite from "error, abort" to "warning, clobber it", so a backup that
# waits for checkout to report conflicts saves the wrong content.
echo "==> Backing up conflicting files to $BACKUP_DIR..."
dotgit ls-tree -r HEAD --name-only | while read -r f; do
    repo_only "$f" && continue
    # -e is false for a dangling symlink, which git would still clobber.
    [ -e "$HOME/$f" ] || [ -L "$HOME/$f" ] || continue
    mkdir -p "$BACKUP_DIR/$(dirname "$f")"
    mv "$HOME/$f" "$BACKUP_DIR/$f"
done

echo "==> Checking out dotfiles..."
dotgit checkout

# Sparse patterns keep the repo-only files out of the checkout, but git still
# diffs any same-named file the user already had in $HOME. skip-worktree stops
# that showing up as a modification forever after.
dotgit ls-tree -r HEAD --name-only | while read -r f; do
    repo_only "$f" || continue
    dotgit update-index --skip-worktree "$f"
done

dotgit config --local status.showUntrackedFiles no

# Install tmux plugin manager (silent if already installed or no tmux)
if command -v tmux >/dev/null; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
fi

echo ""
echo "==> Done. Restart your shell or run: exec zsh"
