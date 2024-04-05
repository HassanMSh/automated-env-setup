#!/bin/bash

echo "Setting up the environment..."

## List of scripts to be excuted

script=(
    "apt_tools.sh"
    "install_brew.sh"
    "install_golang.sh"
    "snap_tools.sh"
    "update_bashrc.sh"
    "helm_repo_add.sh"
    "install_docker.sh"
    "setup_minikube.sh"
    "system_setup.sh"
    "update_kubecontext.sh" 
)

## Execute scripts

exute_scripts() {
    read -pr "Do you want to execute script $1? (y/n) " choice
    case "$choice" in 
        y|Y )
            echo "Executing script $1..."
            . "$1" # ShellCheck can't follow non-constant source. Use a directive to specify location.shellcheck SC1090
            ;;
        n|N ) 
            echo "Skipping script $1..."
            ;;
        * ) 
            echo "Invalid choice. Skipping script $1..."
            ;;
    esac
}

for i in "${script[@]}"; do
    if [ ! -f "$i" ]; then
        echo "File $i not found. Skipping..."
        continue
    fi
    exute_scripts "$i"    
done

echo "Environment setup complete."
echo "Please check the logs for any errors."
cat <<EOF
    To complete the setup, please run the following commands:
    1. source ~/.bashrc
    2. source ~/.bash_aliases
EOF
