# fzf - https://github.com/junegunn/fzf

[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf.zsh ] && source ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf.zsh

if ! command -v fzf >/dev/null 2>&1; then
    return
fi


# check if $MY_THEME is set
if [ -z ${MY_THEME} ]; then
    return
fi

if [ ${MY_THEME} = ${MY_THEME_LIGHT} ]; then
    export FZF_COLORS="bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
else
    export FZF_COLORS="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi


# commands
if command -v fd >/dev/null 2>&1; then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . $1
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . $1
    }
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude ".git" . $@'
fi

export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}

export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls eza exa"


# options
export FZF_DEFAULT_OPTS="--height 60%
    --border rounded
    --layout reverse
    --color ${FZF_COLORS}
    --prompt '∷ '
    --pointer ▶
    --marker ⇒"

if command -v bat >/dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
else
    export FZF_CTRL_T_OPTS="--preview 'cat {}'"
fi

if command -v tree >/dev/null 2>&1; then
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
fi

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color ${FZF_COLORS}
  --header 'Press CTRL-Y to copy command into clipboard'"
