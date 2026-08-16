# ssh-agent
# On macOS, prefer 1Password's SSH agent so git op-ssh-sign and regular ssh
# share one agent. Fall back to launchd/Keychain if 1Password isn't running.
# On Linux, start ssh-agent manually if not already running.

if [ -z "$SSH_CLIENT" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        _op_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        if [ -S "$_op_sock" ]; then
            export SSH_AUTH_SOCK="$_op_sock"
        else
            ssh-add --apple-use-keychain 2>/dev/null
        fi
        unset _op_sock
    elif [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent)" >/dev/null 2>&1
        for key in ~/.ssh/id_*; do
            [[ -f "$key" && "$key" != *.pub ]] && ssh-add "$key" >/dev/null 2>&1
        done
    fi
fi
