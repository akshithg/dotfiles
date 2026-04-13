# CLAUDE.md

## Repository overview

Bare git repo (`~/.dotfiles`) managing `$HOME` config files. This working copy
is for manual editing — the bare repo is the source of truth deployed to `$HOME`.

## Structure

- `.zshenv` — XDG base dirs, PATH, env vars (sourced by all shells)
- `.config/zsh/` — `.zprofile` (login), `.zshrc` (interactive, uses zinit)
- `.source/` — modular shell scripts, each sourced by `.zshrc` in alphabetical order
  - Underscore-prefixed files (`_path.sh`) load first as helpers
  - Every file guards with `command -v <tool> >/dev/null 2>&1 || return`
- `.local/bin/apply-theme` — central theme applier, writes state files for all tools
- `.config/` — tool configs (aerospace, bat, delta, ghostty, git, karabiner, nvim, starship, tmux, vivid)
- `.ssh/` — SSH config with `Include config.d/*.conf`; private keys are gitignored
- `.config/macos/` — macOS defaults and iCloud setup (bash scripts with `set -euo pipefail`)
- `Makefile` — bootstrap (`make clone`), install (`make install`), update (`make update`)

## Conventions

- **Shell files**: All `.source/*.sh` files are zsh, not bash. Use `return` (not `exit`) for early bailout. Guard tool availability before configuring.
- **Theme**: Catppuccin mocha (dark) / latte (light) everywhere. `apply-theme` detects macOS appearance and writes theme state to `$XDG_STATE_HOME/` (delta-theme.gitconfig, tmux-theme.conf, starship.toml). Tool configs include these state files so tracked files stay clean. A zsh precmd hook calls `apply-theme` when appearance changes.
- **XDG compliance**: Configs go in `$XDG_CONFIG_HOME`, caches in `$XDG_CACHE_HOME`, data in `$XDG_DATA_HOME`, state in `$XDG_STATE_HOME`. Never hardcode `~/.config` when a variable exists.
- **Dependencies**: Homebrew for CLI tools, rustup for Rust, uv for Python, fnm for Node. Each installed from its official installer, not from each other.
- **nvim**: LazyVim distribution, tracked inline at `.config/nvim/`. Customize via `lua/plugins/` and `lua/config/`. Run `:LazyExtras` to enable language support modules.

## When editing

- Keep shell files short and focused — one tool per file in `.source/`.
- Don't add shell files that run on every shell startup unless necessary. Prefer lazy loading.
- Lint shell scripts with `shellcheck` before committing.
- Test changes by sourcing the file directly: `source ~/.source/<file>.sh`
- The `dotgit` alias in `.zshrc` operates on the bare repo at `~/.dotfiles`, not this working copy.
