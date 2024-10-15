# ssh-agent

# start ssh-agent if not already running
# and only on local machine
# use Agent Forwarding instead for other hosts

if [ -z "$(pgrep ssh-agent)" ] && [ -z "$SSH_CLIENT" ]; then
    eval "$(ssh-agent)" > /dev/null 2>&1
    # add keys to agent
    ls ~/.ssh/id_* | grep -v '.pub' | xargs ssh-add > /dev/null 2>&1
fi
