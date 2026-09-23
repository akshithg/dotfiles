# 1Password-backed, single-service command environments.
# These dotfiles do not load API keys for ordinary Claude and Codex sessions.

opx() {
  if (( $# < 2 )); then
    print -u2 "usage: opx <anthropic|context7|exa|readwise|upgrade-s3> <command> [args...]"
    return 2
  fi

  local profile=$1
  shift

  case "$profile" in
    anthropic | context7 | exa | readwise | upgrade-s3) ;;
    *)
      print -u2 "opx: unknown profile: $profile"
      return 2
      ;;
  esac

  if ! command -v op >/dev/null 2>&1; then
    print -u2 "opx: 1Password CLI is not installed"
    return 127
  fi

  local env_file="${XDG_CONFIG_HOME}/op/${profile}.env"
  if [[ ! -r "$env_file" ]]; then
    print -u2 "opx: cannot read $env_file; reinstall the dotfiles"
    return 1
  fi

  op run --env-file="$env_file" -- "$@"
}

if command -v s3cmd >/dev/null 2>&1; then
  s3cmd() {
    local executable
    executable=$(whence -p s3cmd) || {
      print -u2 "s3cmd: executable not found"
      return 127
    }
    opx upgrade-s3 "$executable" "$@"
  }
fi

codex-red() {
  CODEX_HOME="$HOME/.codex-red" command codex --profile red "$@"
}
