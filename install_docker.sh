#!/bin/bash

##########################################################
#####                                                #####
#####               Docker Function                  #####
#####                                                #####
##########################################################

docker_install() {
    # Define function to check the success of the last command and exit if there's an error.
    check_error() {
        if [ $? -ne 0 ]; then
            echo "Error: An error occurred during the last command."
            exit 1
        fi
    }

    # Remove existing docker packages
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
        sudo apt-get remove $pkg -y
        check_error
        echo "Removed $pkg"
    done
    
    # Install prerequisites
    sudo apt-get install ca-certificates curl gnupg -y
    check_error
    echo "Installed ca-certificates, curl, and gnupg"

    # Install Docker repository key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    check_error
    echo "Added Docker repository key"

    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    check_error
    echo "Added Docker repository to /etc/apt/sources.list.d/docker.list"

    # Install Docker
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    check_error
    echo "Installed Docker"

    # Add the current user to the docker group to run Docker without sudo (optional)
    sudo usermod -aG docker "$USER"
    check_error
    echo "Added $USER to the docker group"

    # Success message
    echo "Docker installation completed successfully."
}

docker_install
