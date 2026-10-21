#!/usr/bin/env bash
set -euo pipefail

ssh_dir="$HOME/.ssh"
authorized_keys="$ssh_dir/authorized_keys"
github_keys_url="https://github.com/akshithg.keys"

if [[ -L "$ssh_dir" ]]; then
  echo "$ssh_dir is a symlink; make it a local directory before updating authorized_keys." >&2
  exit 1
fi

umask 077
mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"
temp_keys=$(mktemp "$ssh_dir/.authorized_keys.XXXXXXXX")
trap 'rm -f "$temp_keys"' EXIT

if ! curl --fail --silent --show-error --connect-timeout 10 --max-time 30 \
  --proto '=https' --output "$temp_keys" "$github_keys_url"; then
  echo "Could not download SSH keys from $github_keys_url; $authorized_keys was not changed." >&2
  exit 1
fi

key_count=0
while IFS= read -r line || [[ -n "$line" ]]; do
  case "$line" in
    ssh-rsa\ * | ssh-ed25519\ * | ecdsa-sha2-*\ * | sk-ssh-ed25519@openssh.com\ * | sk-ecdsa-sha2-nistp256@openssh.com\ *) ;;
    *)
      echo "Unexpected key data from $github_keys_url; $authorized_keys was not changed." >&2
      exit 1
      ;;
  esac
  ((key_count += 1))
done <"$temp_keys"

if ((key_count == 0)); then
  echo "No SSH keys found at $github_keys_url; $authorized_keys was not changed." >&2
  exit 1
fi

if ! parsed_keys=$(ssh-keygen -lf "$temp_keys" 2>/dev/null) || [[ -z "$parsed_keys" ]]; then
  echo "Invalid SSH keys from $github_keys_url; $authorized_keys was not changed." >&2
  exit 1
fi
parsed_count=$(printf '%s\n' "$parsed_keys" | wc -l | tr -d '[:space:]')
if ((parsed_count != key_count)); then
  echo "Invalid SSH keys from $github_keys_url; $authorized_keys was not changed." >&2
  exit 1
fi

chmod 600 "$temp_keys"
mv "$temp_keys" "$authorized_keys"
trap - EXIT
echo "Installed $key_count GitHub SSH keys in $authorized_keys."
