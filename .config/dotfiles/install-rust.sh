#!/usr/bin/env bash
set -euo pipefail

# rustup + cargo tools

if ! command -v rustup >/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
    sh -s -- -y --no-modify-path
fi

rustup update || rustup install stable
cargo install prek worktrunk cargo-deny cargo-careful
