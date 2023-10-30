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

File          | Interactive Login | Interactive Non-Login | Script
--------------|-------------------|-----------------------|-------
/etc/zshenv   | ✓                 | ✓                     | ✓
~/.zshenv     | ✓                 | ✓                     | ✓
/etc/zprofile | ✓                 |                       |
~/.zprofile   | ✓                 |                       |
/etc/zshrc    | ✓                 | ✓                     |
~/.zshrc      | ✓                 | ✓                     |
/etc/zlogin   | ✓                 |                       |
~/.zlogin     | ✓                 |                       |
~/.zlogout    | ✓                 |                       |
/etc/zlogout  | ✓                 |                       |

## References

1. <https://www.atlassian.com/git/tutorials/dotfiles>
2. <https://wiki.archlinux.org/title/XDG_Base_Directory>

## Misc

```sh
fullpath="/etc/nginx/nginx.conf"
echo "${fullpath:t}" # nginx.conf # tail
echo "${fullpath:h}" # /etc/nginx # head
echo "${fullpath:r}" # /etc/nginx/nginx # root
echo "${fullpath:e}" # conf # extension
echo "${fullpath:a}" # /etc/nginx/nginx.conf # absolute
echo "${fullpath:t:r}" # nginx # tail root
```
