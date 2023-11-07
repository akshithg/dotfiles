# dotfiles

## Prerequisites

1. `zsh` as the default shell
2. `git`

## Initial Setup

```sh
git init --bare $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
```

## On a new system

```sh
git clone --bare git@github.com:akshithg/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
mkdir -p .config-backup && \
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

## Manage

```sh
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles push
```

## Notes

`zsh` file source order:

File                 | Interactive Login | Interactive Non-Login | Script
---------------------|-------------------|-----------------------|-------
/etc/zshenv          | ✓                 | ✓                     | ✓
~/.zshenv            | ✓                 | ✓                     | ✓
/etc/zprofile        | ✓                 |                       |
~${ZDOTDIR}/zprofile | ✓                 |                       |
/etc/zshrc           | ✓                 | ✓                     |
~${ZDOTDIR}/zshrc    | ✓                 | ✓                     |
/etc/zlogin          | ✓                 |                       |
~${ZDOTDIR}/zlogin   | ✓                 |                       |
~${ZDOTDIR}/zlogout  | ✓                 |                       |
/etc/zlogout         | ✓                 |                       |

## References

1. <https://github.com/rothgar/mastering-zsh>
2. <https://www.atlassian.com/git/tutorials/dotfiles>
3. <https://wiki.archlinux.org/title/XDG_Base_Directory>
