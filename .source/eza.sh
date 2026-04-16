# shellcheck shell=bash
# eza — modern ls replacement, fallback to ls

if command -v eza >/dev/null 2>&1; then
    alias ls="eza --group-directories-first"
    alias l="eza"
    alias la="eza -a"
    alias ll="eza -l --git"
    alias lll="eza -la --git"
    alias lt="eza -T --level=2"
else
    if [[ "$OSTYPE" == "darwin"* ]]; then
        alias ls="ls -G"
    else
        alias ls="ls --color=auto"
    fi
    alias l="ls"
    alias la="ls -a"
    alias ll="ls -l"
    alias lll="ls -lhFa"
fi

alias sl="ls"
