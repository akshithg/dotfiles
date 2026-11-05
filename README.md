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

## Git and SSH

Set your Git identity and signing key in a machine-local `~/.gitconfig`. Put
host-specific SSH agent and key choices in `~/.ssh/config.d/local.conf`. The
shared dotfiles do not choose an SSH key provider.

For example, to use an SSH agent for GitHub, add this to `local.conf` and
replace the socket path with the one for that Mac:

```sshconfig
Host github.com
    IdentityAgent "/path/to/agent.sock"
```

For a local or hardware key, use `IdentityFile ~/.ssh/your_key` instead.
