#!/bin/bash

##########################################################
#####                                                #####
#####               APT Function                     #####
#####                                                #####
##########################################################

# Update apt
apt_update() {
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt-get update && sudo apt-get upgrade -y
}

apt_tools=(
    "fastfetch"
    "bash-completion"
    "autossh"
    "curl"
    "net-tools"
    "vim"
    "gparted"
    "htop"
    "iperf"
    "k6"
    "maven"
    "neofetch"
    "nethogs"
    "ngrok"
    "nmap"
    "nmon"
    "openssh-server"
    "plantuml"
    "plocate"
    "tmux"
    "whois"
    "xmlstarlet"
    "yamllint"
    "jq"
    "build-essential"
    "git"
    "openjdk-17-jdk"
    "python3.10"
    "python3.10-venv"
    "python3-pip"
    "pipx"
    "net-tools"
    "postgresql-client"
    "postgresql-client-common"
    "redis-tools"
    "terminator"
    "tmux"
    "vlc"
    "whois"
    "xmlstarlet"
    "yamllint"
)

install_apt_tools() {
    local apt_tools=("$@")

    apt_install_tool() {
        local tool="$1"
        echo "Installing $tool..."
        if sudo apt-get install -y "$tool" | tee -a apt-installation.log; then
            echo "Successfully installed: $tool"
        else
            echo "Error installing: $tool. Check apt-installation.log for details."
            return 1
        fi
    }

    for tool in "${apt_tools[@]}"; do
        apt_install_tool "$tool"
    done
}

apt_update
install_apt_tools "${apt_tools[@]}"
exit 0
