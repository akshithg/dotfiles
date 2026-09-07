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
- `home/.source/secrets.zsh` wraps commands with the 1Password environment.
- `Brewfile` is the package list.
- `install.sh` installs and links the configuration.
- `check.sh` validates shell, JSON, and TOML files.

The shell uses a fixed Catppuccin Mocha theme. Machine-specific settings belong
in the untracked `~/.zshrc.local` file.

## Common commands

```sh
./check.sh
brew update && brew upgrade
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow home
stow --dir="$HOME/.dotfiles" --target="$HOME" --delete home
```

The macOS defaults and iCloud Documents scripts remain opt-in:

```sh
~/.config/macos/defaults.sh
~/.config/macos/setup-icloud.sh
```
