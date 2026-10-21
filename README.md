# dotfiles

macOS CLI setup managed with GNU Stow.

## Install

Install [Homebrew](https://brew.sh), then run:

```sh
git clone git@github.com:akshithg/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

This installs the default `Brewfile`, Rust stable, Node.js 22, and the files in
`home/`. Resolve any Stow conflicts and rerun the installer.

## Optional tools

Run the commands for the groups you want. GUI apps are in `Brewfile.gui`.

```sh
brew bundle --file=Brewfile.shell --no-upgrade
brew bundle --file=Brewfile.dev --no-upgrade
brew bundle --file=Brewfile.gui --no-upgrade
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
