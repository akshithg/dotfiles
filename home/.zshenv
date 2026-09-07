# source by
# ✓ interactive login shell
# ✓ interactive non-login shell
# ✓ scripts
# echo "loading ~/.zshenv"

# Platform detection
case "$(uname -s)" in
    Darwin) export IS_MACOS=1 ;;
    Linux)  export IS_LINUX=1 ;;
esac
if [[ -f /.dockerenv || -n "${container:-}" ]] \
    || grep -qaE '(docker|containerd|kubepods)' /proc/1/cgroup 2>/dev/null; then
    export IS_CONTAINER=1
fi

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
# XDG_RUNTIME_DIR

# PATH
export PATH="${HOME}/.local/bin:${PATH}"

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# zsh
export ZDOTDIR="${HOME}/.config/zsh"

# homebrew (macOS native, Linuxbrew if present)
export HOMEBREW_NO_ANALYTICS=1
[[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:${PATH}"
[[ -d /home/linuxbrew/.linuxbrew/bin ]] && export PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# rust
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export PATH="${CARGO_HOME}/bin:/opt/homebrew/opt/rustup/bin:${PATH}"

# node / fnm (installed via Homebrew)
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node_repl_history"
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
export PATH="${PNPM_HOME}:${PATH}"

# python (not required with uv, only for compatibility)
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PATH="${PYTHONUSERBASE}/bin:${PATH}"

# colima (pin home so contexts without XDG_CONFIG_HOME don't fall back to ~/.colima)
export COLIMA_HOME="${XDG_CONFIG_HOME}/colima"
