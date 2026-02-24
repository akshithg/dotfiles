# uv - https://github.com/astral-sh/uv

if ! command -v uv >/dev/null 2>&1; then
    return
fi

export UV_PYTHON_PREFERENCE="only-managed"
export UV_PYTHON="3"

eval "$(uv --generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv
