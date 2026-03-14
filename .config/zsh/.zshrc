# source by
# ✓ interactive login shell
# ✓ interactive non-login shell
# - scripts
# echo "loading ~/.config/zsh/.zshrc"

# # profiling, check bottom of the file
# zmodload zsh/zprof # uncomment to profile

# If not running interactively, don't do anything
[[ -o interactive ]] || return

#===== zinit =====#
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#===== history =====#
zinit light zsh-users/zsh-history-substring-search # History substring search
bindkey '^[[B' history-substring-search-down
bindkey '^[[A' history-substring-search-up
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh_history"
export HISTSIZE=50000           # Maximum events for internal history
export SAVEHIST=50000           # Maximum events in history file
setopt bang_hist                # treat ! special during command expansion
setopt extended_history         # Write history in :start:elasped;command format
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_space        # prefix command with a space to skip its recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt share_history            # Share history among all sessions (implies inc_append_history)

#===== autosuggestions =====#
typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1
zinit ice silent atload '_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions # Fish-like autosuggestions for zsh

#===== expansions =====#
ZSH_EXPAND_ALL_DISABLE=word # Disable expansion of words
zinit ice silent
zinit light simnalamburt/zsh-expand-all # Expand all aliases Automatically expands all glob expressions, subcommands, and aliases

#===== completions =====#
# Tab-completion / Auto-completion
# '' - complete the current word exactly
# 'm:{a-zA-Z}={A-Za-z}' - handle upper and lower case interchangeable
# 'l:|=* r:|=*' - complete on the left side of the written text, e.g. bar -> foobar
# 'r:|[._-]=* r:|=*' -  partial completion before . or _ or -
zinit ice silent wait'1'
zinit light zsh-users/zsh-completions # Additional completion definitions for Zsh.
zstyle ':completion:*' menu select # show completion menu on successive tab presses
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' file-list all
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
fpath=("$XDG_DATA_HOME"/zsh/completions $fpath)
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort dummyvalue
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Faster `compinit`
autoload -Uz compinit
if [[ -n "${XDG_CACHE_HOME}/zsh/zcompdump"(#qN.mh+24) ]]; then
  compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
else
  compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"
fi

# Completion options
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses
setopt globdots                 # include hidden files in globbing
setopt complete_aliases         # complete aliases
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

#===== other =====#
setopt interactive_comments     # allow # comments in shell; good for copy/paste

#===== theme =====#
export MY_THEME_DARK="dark"
export MY_THEME_LIGHT="light"
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS: detect system theme
  export MY_THEME=$(defaults read -g AppleInterfaceStyle &>/dev/null && echo "$MY_THEME_DARK" || echo "$MY_THEME_LIGHT")
else
  # Non-macOS: default to dark theme
  export MY_THEME="$MY_THEME_DARK"
fi
[ "$MY_THEME" = "$MY_THEME_DARK" ] && zinit snippet https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
[ "$MY_THEME" = "$MY_THEME_LIGHT" ] && zinit snippet https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_latte-zsh-syntax-highlighting.zsh
zinit ice silent wait'1'
zinit light zsh-users/zsh-syntax-highlighting

#===== source, path =====#
[[ -d ~/.source ]] && for file in ~/.source/*; do [[ -f "$file" ]] && source "$file"; done
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
typeset -U path                 # remove duplicates in $PATH

#===== local =====#
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# zprof # uncomment to profile
