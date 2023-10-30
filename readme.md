# dotfiles

## Prerequisites

`git`

## Setup

```sh
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

## Manage

```sh
config status
config add .vimrc
config commit -m "Add vimrc"
config add .config/redshift.conf
config commit -m "Add redshift config"
config push
```
