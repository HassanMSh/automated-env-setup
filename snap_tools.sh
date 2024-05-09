#!/bin/bash

##########################################################
#####                                                #####
#####               Snap Function                    #####
#####                                                #####
##########################################################

snap_packages=(
    "helm3 --classic" 
    "popeye" 
    "kubectl --classic"
    "intellij-idea-community --classic"
    "code --classic"
    "node --classic"
    "sublime-text --classic"
    "telegram-desktop"
    "yq"
    "tree"
    "vnstat"
    "yq"
    "telegram-desktop"
    "sublime-text"
    "gnome-42-2204"
)

install_snap_packages() {
    local snap_packages=("$@")
    
    snap_install_package() {
        local package="$1"
        echo "Installing $package..."
        if sudo snap install "$package" | tee -a snap-installation.log; then
            echo "Successfully installed: $package"
        else
            echo "Error installing: $package. Check snap-installation.log for details."
            return 1
        fi
    }
    
    for package in "${snap_packages[@]}"; do
        snap_install_package "$package"
    done
}

install_snap_packages "${snap_packages[@]}"
