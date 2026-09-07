# 1Password-backed command environments

if command -v op >/dev/null 2>&1; then
  OP_ENV_FILE="${XDG_CONFIG_HOME}/op/env.tpl"

  if [[ -f "$OP_ENV_FILE" ]]; then
    _op_wrap_cmd() {
      local command_name=$1
      command -v "$command_name" >/dev/null 2>&1 || return
      unalias "$command_name" 2>/dev/null
      eval "function $command_name { (set -a; eval \"\$(op inject -i \"\$OP_ENV_FILE\" 2>/dev/null)\"; set +a; command $command_name \"\$@\") }"
    }

    _op_wrap_cmd claude
    _op_wrap_cmd codex
    _op_wrap_cmd s3cmd

    opx() {
      (set -a; eval "$(op inject -i "$OP_ENV_FILE" 2>/dev/null)"; set +a; "$@")
    }
  fi
fi

alias codex-cyber="codex -m gpt-5.6-cyber \
  --config 'model_reasoning_effort=\"xhigh\"' \
  --config 'model_provider=\"openai-ptp\"' \
  --config 'model_providers.openai-ptp.name=\"OpenAI PTP\"' \
  --config 'model_providers.openai-ptp.base_url=\"https://api.openai.com/v1\"' \
  --config 'model_providers.openai-ptp.wire_api=\"responses\"' \
  --config 'model_providers.openai-ptp.auth.command=\"/opt/homebrew/bin/op\"' \
  --config 'model_providers.openai-ptp.auth.args=[\"item\",\"get\",\"OPENAI_PTP_API_KEY\",\"--fields\",\"password\",\"--reveal\"]' \
  --config 'model_providers.openai-ptp.auth.timeout_ms=60000'"
