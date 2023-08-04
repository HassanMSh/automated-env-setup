# Automated Environment Setup

This bash script is designed to automate the process of setting up various tools and packages on your system. It performs the following tasks:

1. Updates and upgrades the system packages using `apt`.
2. Installs essential packages through `apt`, including `bash-completion`, `curl`, `vim`, `htop`, `iperf`, `maven`, and more.
3. Installs additional packages using `snap`, such as `helm3`, `popeye`, and `kubectl`.
4. Sets up Docker by adding the Docker repository and installing `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, and `docker-compose-plugin`.
5. Updates the `~/.bashrc` file with custom aliases, kubectl completion, and a custom prompt configuration.
6. Installs Minikube and sets up the kubeconfig file for Kubernetes context switching.
7. Adds a script to automate Kubernetes context switching in `~/.local/bin/kcc.sh`.
8. Sets up various Helm repositories, enabling easy access to various charts.
9. Installs Go 1.20.6 and adds it to the system PATH.

## Usage

1. Clone the repository or copy the contents of the script into a file named `system_setup.sh`.
2. Make the script executable: `chmod +x system_setup.sh`.
3. Comment any funtion at the end of the script that you do not want to excute. 
4. Run the script with `./system_setup.sh`.

Please note that this script may require root privileges for some tasks, so you may be prompted to enter your password when running it. It's essential to review the script and make any necessary adjustments before executing it on your system.

## Disclaimer

This script is provided as-is and without any warranties. Use it at your own risk. Ensure you have a recent backup of your system before running the script to avoid data loss or system misconfiguration.

Always check for the latest package versions, repository URLs, and other configurations to ensure the script remains up-to-date and works correctly on your system.

Remember to review the script thoroughly and understand its operations before running it on your machine.

## Future

I will enhance the script and add more features and an Ansible adaptation playbooks. If you have any suggestions/recommendations or bugs to report please do let me know.
