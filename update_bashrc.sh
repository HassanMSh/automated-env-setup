#!/bin/bash

##########################################################
#####                                                #####
#####                   bashrc                       #####
#####                                                #####
##########################################################

update_bashrc() {
    bashrc_content=$(cat << 'EOF'

## Aliases

alias k='kubectl'
alias kc='sudo bash ~/.local/bin/kcc.sh'
alias c='clear'
alias claer='clear'
alias clare='clear'
alias calre='clear'
alias git-logs='git log --oneline --decorate --graph'

## kubectl

source <(kubectl completion bash)

complete -o default -F __start_kubectl k

## Linode CLI

LINODE_CLI_TOKEN=""

## kubeconfig

alias kc='bash /home/minikube/.local/bin/kcc.sh'

## bash prompt

### get current branch in git repo

function parse_git_dirty() {
    # Check for modifications
    if git status 2> /dev/null | grep -q "nothing to commit, working tree clean" && git status 2> /dev/null | grep -q "Your branch is up to date with"; then
        echo ""
    else
    echo "*"
    fi
}

function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
                STAT=`parse_git_dirty`
                echo "[${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

### Prompt

export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[33m\]\`parse_git_branch\`\[\e[m\]\\$ "

## JAVA
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")

## Brew

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## GitLab Read API

export CI_API_V4_URL=https://gitlab.com/api/v4
EOF
)
    echo "$bashrc_content" >> ~/.bashrc
    echo ".bashrc was updated"
}