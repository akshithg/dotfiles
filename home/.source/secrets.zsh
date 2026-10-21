# 1Password-backed command profiles.

opx() {
  local -a op_flags
  if [[ "${1:-}" == --no-masking ]]; then
    op_flags=(--no-masking)
    shift
  fi

  if (( $# < 2 )); then
    print -u2 "usage: opx [--no-masking] <all|anthropic|context7|exa|readwise|typesafe|upgrade|ynab> <command> [args...]"
    return 2
  fi

  local profile=$1
  shift

  case "$profile" in
    all | anthropic | context7 | exa | readwise | typesafe | upgrade | ynab) ;;
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
    print -u2 "opx: cannot read $env_file; create the machine-local profile"
    return 1
  fi

  op run "${op_flags[@]}" --env-file="$env_file" -- "$@"
}

if command -v s3cmd >/dev/null 2>&1; then
  s3cmd() {
    local executable
    executable=$(whence -p s3cmd) || {
      print -u2 "s3cmd: executable not found"
      return 127
    }
    opx upgrade "$executable" "$@"
  }
fi
