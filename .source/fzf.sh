# fzf - https://github.com/junegunn/fzf

if ! command -v fzf >/dev/null 2>&1; then
    return
fi

# completion
eval "$(fzf --zsh)"

# theme
if [ "${MY_THEME}" = "${MY_THEME_LIGHT}" ]; then
    export FZF_COLORS="bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
else
    export FZF_COLORS="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

# commands — prefer fd (handles dirs natively), fall back to rg + find
if command -v fd >/dev/null 2>&1; then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude ".git"'
elif command -v rg >/dev/null 2>&1; then
    _fzf_compgen_path() {
        rg --files --hidden --follow --glob "!.git/*" "$1"
    }

    _fzf_compgen_dir() {
        find "$1" -type d -not -path '*/.git/*'
    }
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
else
    _fzf_compgen_path() {
        compgen -f "$1"
    }

    _fzf_compgen_dir() {
        compgen -d "$1"
    }
    export FZF_DEFAULT_COMMAND='find * -path "*/\.*" -prune -o -type f -print -o -type l -print 2> /dev/null'
fi

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls eza"

# options
export FZF_DEFAULT_OPTS="--height 60%
    --border rounded
    --layout reverse
    --color ${FZF_COLORS}
    --prompt '∷ '
    --pointer ▶
    --marker ⇒"

if command -v bat >/dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'bat -n --color=always {}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"
else
    export FZF_CTRL_T_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'cat {} | head -n 100'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"
fi

if command -v tree >/dev/null 2>&1; then
    export FZF_ALT_C_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'tree -C {}'"
fi

if command -v pbcopy >/dev/null 2>&1; then
    _fzf_clip="pbcopy"
elif command -v wl-copy >/dev/null 2>&1; then
    _fzf_clip="wl-copy"
elif command -v xclip >/dev/null 2>&1; then
    _fzf_clip="xclip -selection clipboard"
fi

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | ${_fzf_clip})+abort'
  --header 'Press CTRL-Y to copy command into clipboard'"
