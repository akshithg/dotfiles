# dotfiles

macOS configuration installed from a normal Git checkout with GNU Stow.

## Install

Install [Homebrew](https://brew.sh), then run:

```sh
git clone git@github.com:akshithg/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` installs the packages in `Brewfile`, links the contents of `home/`
into `$HOME`, and initializes the configured Rust, Node.js, and Python tools.
Stow stops without replacing existing files, so move any reported conflicts out
of the way and run the script again.

## Layout

- `home/` mirrors paths below `$HOME`.
- `home/.source/aliases.zsh` contains aliases.
- `home/.source/functions.zsh` contains interactive helper functions.
- `home/.source/tools.zsh` initializes command-line tools.
- `home/.source/secrets.zsh` gives commands an explicit, single-service
  1Password environment.
- `Brewfile` is the package list.
- `install.sh` installs and links the configuration.
- `check.sh` validates shell, JSON, and TOML files.

Ghostty follows macOS appearance using Catppuccin Latte for light mode and
Mocha for dark mode. Herdr switches with the terminal appearance; other terminal
tools inherit the active palette where supported.
Machine-specific settings belong in the untracked `~/.zshrc.local` file.

## Common commands

```sh
./check.sh
brew update && brew upgrade
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow home
stow --dir="$HOME/.dotfiles" --target="$HOME" --delete home
```

Run `s3cmd` normally; its wrapper loads only the two credentials in the
`upgrade-s3` profile. Normal `claude` and `codex` sessions use their own login;
these dotfiles do not load API keys for them. For an exceptional command that
requires one API key, select its profile explicitly:

```sh
opx exa command-that-needs-exa
opx anthropic command-that-needs-anthropic
```

The profile files under `~/.config/op` contain only 1Password secret references.
`op run` resolves a selected profile for the lifetime of its child process.

Run `codex` for subscription sessions without a pinned default model. Run
`codex-red` for the API-backed red model. It selects the `red` profile under
`~/.codex-red`, so its session history stays separate from regular Codex. The
profile fetches its API key from 1Password when Codex needs it and uses the
model catalog at `~/.codex-red/models/daybreak.json`.

The macOS defaults and iCloud Documents scripts remain opt-in:

```sh
~/.config/macos/defaults.sh
~/.config/macos/setup-icloud.sh
```
