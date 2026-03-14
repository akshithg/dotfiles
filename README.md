# dotfiles

Bare git repo managing `$HOME` config files.

## What's managed

```
.zshenv                     # XDG dirs, ZDOTDIR, env vars
.config/
  bat/                      # syntax highlighting + catppuccin themes
  delta/                    # diff pager
  ghostty/                  # terminal
  git/config, ignore        # git config + global gitignore
  karabiner/
  macos/
  nvim/                     # kickstart-based, as a submodule
  tmux/                     # tmux
  vivid/                    # LS_COLORS themes
  zsh/                      # shell config (zinit, completions, theme)
  starship.toml             # prompt
.source/                    # modular shell scripts sourced by .zshrc
.ssh/                       # ssh config, authorized_keys (keys are gitignored)
```

## Setup on a new machine

Prerequisites: `git`, `zsh`, macOS (homebrew-based setup).

```sh
# clone
git clone --bare git@github.com:akshithg/dotfiles.git $HOME/.dotfiles

# alias for this session
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# back up any conflicting files, then checkout
mkdir -p ~/.config-backup
dotfiles checkout 2>&1 | grep -E "^\s" | awk '{print $1}' | xargs -I{} mv {} ~/.config-backup/{}
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

Or use the Makefile:

```sh
make clone          # clone bare repo + checkout + TPM
make install        # brew + rust + python + node tools
make install-brew   # homebrew + CLI tools (includes node)
make install-rust   # rustup + cargo tools (prek, cargo-deny, etc.)
make install-python # uv (from astral.sh) + ruff, ty, pip-audit
make install-node   # pnpm + global packages
make update         # upgrade all tools
```

Homebrew, Rust, and uv are each installed from their official web installers
(not from each other). Node comes from homebrew; pnpm and global packages
are managed separately in `install-node`.

## Usage

The alias `dotfiles` is defined in `.zshrc`. After setup:

```sh
dotfiles status
dotfiles add .config/ghostty/config
dotfiles commit -m "update ghostty config"
dotfiles push
```

## Shell loading order

`.zshenv` sets XDG dirs and `ZDOTDIR=$HOME/.config/zsh`, then:

1. `.zshenv` — XDG paths, editor, paths for brew, rust, python, node (all shells)
2. `.config/zsh/.zprofile` — homebrew shellenv (login shells)
3. `.config/zsh/.zshrc` — zinit, completions, theme, sources `.source/*` (interactive)

## References

- [Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles)
- [mastering zsh](https://github.com/rothgar/mastering-zsh)
- [XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory)
