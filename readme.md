# dotfiles

Bare git repo managing `$HOME` config files. Uses [this approach](https://www.atlassian.com/git/tutorials/dotfiles).

## What's managed

```
.zshenv                     # XDG dirs, ZDOTDIR, env vars
.config/
  zsh/.zshrc, .zprofile     # shell config (zinit, completions, theme)
  git/config, ignore        # git config + global gitignore
  ghostty/config            # terminal
  nvim/                     # neovim (kickstart-based)
  starship.toml             # prompt
  bat/                      # syntax highlighting + catppuccin themes
  vivid/                    # LS_COLORS themes
  tmux/tmux.conf            # tmux
  delta/delta.gitconfig     # diff pager
.source/                    # modular shell scripts sourced by .zshrc
.ssh/config, config.d/      # ssh config (keys are gitignored)
.claude/
  CLAUDE.md                 # global instructions for Claude Code
  settings.json             # model, permissions, hooks, plugins
  statusline.sh             # custom status line script
  commands/trailofbits/     # Trail of Bits slash command
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
make install-node   # pnpm + global packages (claude-code-devcontainer)
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

1. `.zshenv` — XDG paths, editor, cargo/python env (all shells)
2. `.config/zsh/.zprofile` — homebrew shellenv (login shells)
3. `.config/zsh/.zshrc` — zinit, completions, theme, sources `.source/*` (interactive)

## Claude Code

Configuration based on [trailofbits/claude-code-config](https://github.com/trailofbits/claude-code-config).

- **`CLAUDE.md`** — global coding standards, tool preferences, language-specific rules
- **`settings.json`** — default model (`opus`), deny-list permissions (blocks `rm -rf`, credential reads, force pushes), pre-tool-use hooks, status line, plugin config
- **`statusline.sh`** — two-line status bar showing model, folder, branch, context usage, cost, and session duration
- **`commands/trailofbits/config.md`** — `/trailofbits:config` slash command

Ephemeral state (`history.jsonl`, `debug/`, `plans/`, `plugins/`, etc.) is not tracked.

## References

- <https://www.atlassian.com/git/tutorials/dotfiles>
- <https://github.com/rothgar/mastering-zsh>
- <https://wiki.archlinux.org/title/XDG_Base_Directory>
- <https://github.com/trailofbits/claude-code-config>
