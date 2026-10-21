#!/usr/bin/env bash
set -euo pipefail

fallback_key="$HOME/.ssh/git_signing_fallback_ed25519"
allowed_signers="$HOME/.ssh/allowed_signers"
email=
if ! email=$(git config user.email) || [[ -z "$email" ]]; then
  echo 'setup-fallback-signing.sh: set git user.email before creating a signing key.' >&2
  exit 1
fi
if [[ ! -f "$allowed_signers" ]]; then
  echo "setup-fallback-signing.sh: $allowed_signers is missing; run install.sh first." >&2
  exit 1
fi
if [[ -e "$fallback_key" && ! -e "$fallback_key.pub" ]] ||
  [[ ! -e "$fallback_key" && -e "$fallback_key.pub" ]]; then
  echo 'setup-fallback-signing.sh: only one half of the fallback key pair exists; resolve it manually.' >&2
  exit 1
fi

if [[ ! -e "$fallback_key" ]]; then
  umask 077
  ssh-keygen -t ed25519 -f "$fallback_key" -C "$email"
fi

public_key=$(<"$fallback_key.pub")
if ! grep -Fq -- "$public_key" "$allowed_signers"; then
  printf '%s %s\n' "$email" "$public_key" >>"$allowed_signers"
  echo "Added the public key to $allowed_signers (tracked in dotfiles)."
fi

echo "Local fallback key: $fallback_key"
echo "Add $fallback_key.pub to GitHub as a signing key:"
echo "  gh ssh-key add '$fallback_key.pub' --type signing"
