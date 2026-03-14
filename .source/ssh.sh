# ssh-agent
# macOS launchd manages ssh-agent; just load keys from Keychain.
# On non-macOS, start agent manually if not running.

if [ -z "$SSH_CLIENT" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ssh-add --apple-use-keychain 2>/dev/null
    elif [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent)" >/dev/null 2>&1
        for key in ~/.ssh/id_*; do
            [[ -f "$key" && "$key" != *.pub ]] && ssh-add "$key" >/dev/null 2>&1
        done
    fi
fi
