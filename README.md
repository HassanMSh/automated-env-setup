# System Setup Scripts

This repository contains a collection of scripts to streamline the setup and configuration of a system. Below are brief descriptions of each script along with instructions on how to use them.

## Scripts

1. **apt_tools.sh**: Installs essential tools and utilities using the APT package manager on Debian-based systems.

2. **helm_repo_add.sh**: Adds Helm repositories to your system for managing Kubernetes applications.

3. **install_brew.sh**: Installs the Homebrew package manager on macOS or Linux.

4. **install_docker.sh**: Installs Docker, a platform for developing, shipping, and running applications in containers.

5. **install_golang.sh**: Installs the Go programming language on your system.

6. **setup_minikube.sh**: Sets up Minikube, a tool for running Kubernetes clusters locally.

7. **snap_tools.sh**: Installs various tools and utilities using the Snap package manager.

8. **system_setup.sh**: The main setup script that orchestrates the execution of other scripts. Follow the usage instructions below.

9. **update_bashrc.sh**: Updates the Bash configuration file for custom settings.

10. **update_kubecontext.sh**: Updates the Kubernetes context configuration.

## Usage

1. Clone the repository or copy the contents of the script into a file named `system_setup.sh`.
2. Make the script executable: `chmod +x system_setup.sh`.
3. Comment out any function at the end of the script that you do not want to execute.
4. Run the script with `./system_setup.sh`.

Please note that this script may require root privileges for some tasks, so you may be prompted to enter your password when running it. It's essential to review the script and make any necessary adjustments before executing it on your system.

## Disclaimer

This script is provided as-is and without any warranties. Use it at your own risk. Ensure you have a recent backup of your system before running the script to avoid data loss or system misconfiguration.

Always check for the latest package versions, repository URLs, and other configurations to ensure the script remains up-to-date and works correctly on your system.

Remember to review the script thoroughly and understand its operations before running it on your machine.

## Future

I will enhance the script and add more features, as well as create Ansible adaptation playbooks. If you have any suggestions, recommendations, or bugs to report, please let me know.

