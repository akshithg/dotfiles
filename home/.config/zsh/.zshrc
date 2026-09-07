[[ -o interactive ]] || return

typeset -U path fpath
mkdir -p "${XDG_CACHE_HOME}/zsh" "${XDG_STATE_HOME}"

# History
export HISTFILE="${XDG_STATE_HOME}/zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
setopt bang_hist extended_history hist_expire_dups_first hist_find_no_dups
setopt hist_ignore_dups hist_ignore_space hist_reduce_blanks hist_verify share_history

# Completion
fpath=("$HOME/.docker/completions" $fpath)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' file-list all
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
if [[ -n "${XDG_CACHE_HOME}/zsh/zcompdump"(#qN.mh+24) ]]; then
  compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
else
  compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"
fi

setopt complete_in_word auto_menu globdots complete_aliases interactive_comments
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# Homebrew-managed shell plugins
if [[ -r /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
  source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey '^[[B' history-substring-search-down
  bindkey '^[[A' history-substring-search-up
fi

[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Personal shell configuration, loaded explicitly.
source "$HOME/.source/tools.zsh"
source "$HOME/.source/functions.zsh"
source "$HOME/.source/aliases.zsh"
source "$HOME/.source/secrets.zsh"

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Syntax highlighting must be loaded last.
[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
