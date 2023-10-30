# source by
# ✓ interactive login shell
# ✓ interactive non-login shell
# ✓ scripts
# echo "loading .zshenv"

# XDG
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_STATE_HOME=${HOME}/.local/state
# editor
export EDITOR="vim"
export VISUAL="vim"

# zsh
export ZDOTDIR=${HOME}/.config/zsh
export HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/history
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

# cargo
export CARGO_HOME=${XDG_DATA_HOME}/cargo
[ -f ${CARGO_HOME}/env ] && source ${CARGO_HOME}/env

# python
export PYTHONPYCACHEPREFIX=${XDG_CACHE_HOME}/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
