# claude code

if ! command -v claude >/dev/null 2>&1; then
    return
fi

alias claude-yolo="claude --dangerously-skip-permissions"

claude-local() {
  ANTHROPIC_BASE_URL=http://localhost:1234 \
  ANTHROPIC_AUTH_TOKEN=lmstudio \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  claude "$@"
}
