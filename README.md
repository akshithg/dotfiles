# dotfiles

macOS CLI setup managed with GNU Stow.

## Install

Install [Homebrew](https://brew.sh), then clone the repository:

```sh
git clone git@github.com:akshithg/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The command lists available groups without changing anything. Run
`./install.sh core` for all formulas and dotfiles; resolve any Stow conflicts
and rerun it. Run `./install.sh cask` for optional apps and fonts. Run
`./install.sh defaults` to apply macOS and app preferences; it restarts affected
apps.

## Optional tools

For other package managers, run:

```sh
./install-tools.sh cargo uv pnpm
```

`install-tools.sh` accepts any subset of `cargo`, `uv`, and `pnpm`; package lists
are in `tools/`.

## SSH access

To replace the local `~/.ssh/authorized_keys` with the public keys currently on
the `akshithg` GitHub account, run:

```sh
./setup-authorized-keys.sh
```

This is a separate setup step. It does not run during `./install.sh`.

## Git signing

Git uses 1Password signing when available. Otherwise, it announces and uses a
local SSH key. Set up that key on machines that need it:

```sh
./setup-fallback-signing.sh
```

Add `~/.ssh/git_signing_fallback_ed25519.pub` to GitHub as a signing key. The
script also adds it to the tracked `home/.ssh/allowed_signers` file; review that
change before committing.
