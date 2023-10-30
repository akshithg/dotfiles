# ssh-agent

# start ssh-agent
if [ -z ${SSH_AUTH_SOCK} ] ; then
    eval "$(ssh-agent)" > /dev/null 2>&1
fi

# add keys to agent
ssh-add "$(ls ~/.ssh/id_* | grep -v '.pub')" > /dev/null 2>&1
