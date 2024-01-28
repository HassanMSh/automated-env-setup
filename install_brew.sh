#!/bin/bash

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# install brew packages

brew_tools=(
    "xq"
)

install_brew_tools() {
    local brew_tools=("$@")

    brew_install_tool() {
        local tool="$1"
        echo "Installing $tool..."
        if brew install "$tool" | tee -a brew-installation.log; then
            echo "Successfully installed: $tool"
        else
            echo "Error installing: $tool. Check brew-installation.log for details."
            return 1
        fi
    }

    for tool in "${brew_tools[@]}"; do
        brew_install_tool "$tool"
    done
}

install_brew_tools "${brew_tools[@]}"
