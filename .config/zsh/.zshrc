# source by
# ✓ interactive login shell
# ✓ interactive non-login shell
# - scripts
# echo "loading .zshrc"

# profiling, check bottom of the file
# zmodload zsh/zprof # uncomment to profile

# If not running interactively, don't do anything
[[ -o interactive ]] || return

#
# zinit
#
autoload -U is-at-least
if is-at-least 5.1; then

    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
    [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    source "${ZINIT_HOME}/zinit.zsh"


    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit

    # Auto suggestions
    if is-at-least 5.0.8; then
        typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1
    fi
    if is-at-least 5.3; then
        zinit ice silent wait'1' atload '_zsh_autosuggest_start'
    fi

    # Autosuggestions
    zinit light zsh-users/zsh-autosuggestions

    # Expand all aliases
    ZSH_EXPAND_ALL_DISABLE=word # All features enabled ('', word, alias)
    zinit light simnalamburt/zsh-expand-all

    # History substring search
    zinit light zsh-users/zsh-history-substring-search

    # Other
    # zinit light zsh-users/zsh-completions

    autoload -Uz compinit
    compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
    zinit cdreplay

    #
    # zsh options http://zsh.sourceforge.net/Doc/Release/Options.html
    #

    # History settings
    export HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/history
    export HISTSIZE=10000           # Maximum events for internal history
    export SAVEHIST=10000           # Maximum events in history file
    setopt append_history           # allow multiple sessions to append to one history
    setopt bang_hist                # treat ! special during command expansion
    setopt extended_history         # Write history in :start:elasped;command format
    setopt hist_expire_dups_first   # expire duplicates first when trimming history
    setopt hist_find_no_dups        # When searching history, don't repeat
    setopt hist_ignore_dups         # ignore duplicate entries of previous events
    setopt hist_ignore_space        # prefix command with a space to skip it's recording
    setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
    setopt hist_verify              # Don't execute immediately upon history expansion
    setopt inc_append_history       # Write to history file immediately, not when shell quits
    setopt share_history            # Share history among all sessions
    bindkey '^[[B' history-substring-search-down
    bindkey '^[[A' history-substring-search-up

    # Tab-completion / Auto-completion
    # '' - complete the current word exactly
    # 'm:{a-zA-Z}={A-Za-z}' - handle upper and lower case interchangeable
    # 'l:|=* r:|=*' - complete on the left side of the written text, e.g. bar -> foobar
    # 'r:|[._-]=* r:|=*' -  partial completion before . or _ or -
    zstyle ':completion:*' menu select # show completion menu on succesive tab presses
    zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    zstyle ':completion:*' file-list all
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
    zstyle ':completion:*' squeeze-slashes true
    zstyle ':completion:*' complete-options true
    zstyle ':completion:*' file-sort dummyvalue
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

    setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
    setopt auto_menu                # show completion menu on succesive tab presses
    # setopt autocd                   # cd to a folder just by typing it's name
    setopt globdots                 # include hidden files in globbing
    setopt complete_aliases         # complete aliases
    ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

    # Misc
    setopt interactive_comments     # allow # comments in shell; good for copy/paste

    # Path
    typeset -U path                 # keep duplicates out of the path

    # detect system theme
    export MY_THEME_DARK="dark"
    export MY_THEME_LIGHT="light"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ -z $(defaults read -g AppleInterfaceStyle 2> /dev/null ) ]; then
            export MY_THEME=$MY_THEME_LIGHT
        else
            export MY_THEME=$MY_THEME_DARK
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then # TODO: Add support for other OSes
        if [[ "$(gsettings get org.gnome.desktop.interface gtk-theme 2> /dev/null | tr '[:upper:]' '[:lower:]')" == *"dark"* ]]; then
            export MY_THEME=$MY_THEME_DARK
        else
            export MY_THEME=$MY_THEME_LIGHT
        fi
    else
        if [ -z $MY_THEME ]; then
            export MY_THEME=$MY_THEME_DARK
        fi
    fi

    # starship prompt
    if command -v starship > /dev/null 2>&1 ; then
        eval "$(starship init zsh)"
    fi

    # local config
    if [ -f ~/.zshrc.local ]; then
        source ~/.zshrc.local
    fi

    alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    # source all files in ~/.source - paths, aliases, functions, etc.
    if [ -d ~/.source ]; then
        for file in ~/.source/*; do
            source $file
        done
    fi

    # Syntax highlighting - must be last
    [ $MY_THEME = $MY_THEME_DARK ] && zinit snippet https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
    [ $MY_THEME = $MY_THEME_LIGHT ] && zinit snippet https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_latte-zsh-syntax-highlighting.zsh
    zinit light zsh-users/zsh-syntax-highlighting

else
    # Default terminal
    case "$TERM" in
        xterm-color|*-256color)
        PS1=$'\e[1;32m%n@%m\e[0m:\e[1;34m%~\e[0m%(!.#.$) ';;
        *)
        PS1='%n@%m:%~%(!.#.$) ';;
    esac
    autoload -Uz compinit
    compinit "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
fi

# zprof # uncomment to profile
