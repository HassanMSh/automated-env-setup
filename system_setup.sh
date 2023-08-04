#!/bin/bash

sudo apt update -y && sudo apt -y upgrade

##########################################################
#####                                                #####
#####               APT Function                     #####
#####                                                #####
##########################################################

apt_tools=(
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

##########################################################
#####                                                #####
#####               Snap Function                    #####
#####                                                #####
##########################################################

snap_packages=(
    "helm3 --classic" 
    "popeye" 
    "kubectl --classic"
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
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(./etc/os-release && echo \$VERSION_CODENAME) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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

##########################################################
#####                                                #####
#####                   bashrc                       #####
#####                                                #####
##########################################################

update_bashrc() {
    bashrc_content=$(cat << 'EOF'

######################
## Aliases

alias k='kubectl'
alias c='clear'

# curl cht.sh

_cht_complete()
{
    local cur prev opts
    _get_comp_words_by_ref -n : cur

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(curl -s cheat.sh/:list)"

    if [ ${COMP_CWORD} = 1 ]; then
          COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
          __ltrim_colon_completions "$cur"
    fi
    return 0
}

complete -F _cht_complete cht.sh
[[ -r "/etc/profile.d/bash_completion.sh" ]] && . "/etc/profile.d/bash_completion.sh"

## kubectl

source <(kubectl completion bash)

complete -o default -F __start_kubectl k

## Linode CLI

LINODE_CLI_TOKEN=""

## kubeconfig

alias kc='bash ~/.local/bin/kcc.sh'

## bash promt

# get current branch in git repo
function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
                echo "[${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

# export
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[33m\]\`parse_git_branch\`\[\e[m\]\\$ "

# JAVA
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")

EOF
)
    echo "$bashrc_content" >> ~/.bashrc
    echo "bashrc was updated"
}

##########################################################
#####                                                #####
#####          minikube Setup Function               #####
#####                                                #####
##########################################################

minikube_install() {

    if curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 | tee -a minikube-download.log; then
        echo "Succesfully downloaded minikube"
    else
        echo "Error downloading minikube. Check minikube-download.log for details."
        exit 1
    fi

    if sudo install minikube-linux-amd64 /usr/local/bin/minikube -y | tee -a minikube-install.log; then
        echo "Succesfully installed minikube"
    else
        echo "Error installed minikube. Check minikube-install.log for details."
        exit 1
    fi
}

##########################################################
#####                                                #####
#####                 kubecontext                    #####
#####                                                #####
##########################################################

update_kubecontext() {

    kubecontext=$(cat << 'EOF'
apiVersion: v1
clusters:
- cluster:
    certificate-authority: ~/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Fri, 07 Jul 2023 12:50:15 EEST
        provider: minikube.sigs.k8s.io
        version: v1.29.0
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
- cluster:
    server: https://xyz.com
  name: xyz
contexts:
- context:
    cluster: xyz
    namespace: central
    user: xyz
  name: central
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Wed, 31 May 2023 17:10:45 EEST
        provider: minikube.sigs.k8s.io
        version: v1.29.0
      name: context_info
    namespace: monitoring
    user: minikube
  name: default
- context:
    cluster: xyz
    namespace: dev-ops-shams
    user: xyz
  name: dev-ops-shams
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Fri, 07 Jul 2023 12:50:15 EEST
        provider: minikube.sigs.k8s.io
        version: v1.29.0
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: dev-ops-shams
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: ~/.minikube/profiles/minikube/client.crt
    client-key: ~/.minikube/profiles/minikube/client.key
- name: xyz
  user:
    token: 
EOF
)
    echo "$kubecontext" > ~/.kube/config.backup
    echo "kubecontext backup was added."
}

# Adding automatic kubecontect change script
add_kc() {
    kc=$(cat << 'EOF'
#!/bin/bash

cd ~/.kube || exit

kubectl config --kubeconfig=config use-context $1
EOF
)
    echo "$kc" > ~/.local/bin/kcc.sh
    echo "kubecontext script was added."
}

##########################################################
#####                                                #####
#####                 Helm Repos                     #####
#####                                                #####
##########################################################

helm_repo_add() {
    # Define the 2-dimensional array (simulated using two separate arrays)
    helm_repo_names=(
        "oauth2-proxy"
        "jetstack"
        "grafana"
        "vmware-tanzu"
        "apache"
        "rancher-latest"
        "influxdata"
        "sonarqube"
        "prometheus-community"
    )

    helm_repo_urls=(
        "https://oauth2-proxy.github.io/manifests"
        "https://charts.jetstack.io"
        "https://grafana.github.io/helm-charts"
        "https://vmware-tanzu.github.io/helm-charts"
        "https://pulsar.apache.org/charts"
        "https://releases.rancher.com/server-charts/latest"
        "https://helm.influxdata.com/"
        "https://SonarSource.github.io/helm-chart-sonarqube"
        "https://prometheus-community.github.io/helm-charts"
    )
    
    # Loop through the array and download Helm repos
    for ((i=0; i<${#helm_repo_names[@]}; i++))
    do
        repo_name="${helm_repo_names[$i]}"
        repo_url="${helm_repo_urls[$i]}"
        
        # Adding Helm repository using 'helm repo add'
        helm repo add "$repo_name" "$repo_url"
        
        # list the repositories to verify if it was added correctly
        helm repo list | grep "$repo_name"
    
    done
    
    helm repo update
    echo "Helm repos were succesfully added"
}

##########################################################
#####                                                #####
#####                 Install Go                     #####
#####                                                #####
##########################################################

install_golang() {
    go_file="go1.20.6.linux-amd64.tar.gz"
    wget "https://dl.google.com/go/$go_file"
    echo $go_file was downloalded succefully.
    sudo tar xvfz "$go_file" -C /usr/local/
    rm -f "$go_file"
    export PATH=$PATH:/usr/local/go/bin
    echo "$(go version)" was succefully installed.
}

##########################################################
#####                                                #####
#####               call functions                   #####
#####                                                #####
##########################################################


install_apt_tools "${apt_tools[@]}"

install_snap_packages "${snap_packages[@]}"

docker_install

update_bashrc

minikube_install

update_kubecontext

add_kc

helm_repo_add

install_golang
