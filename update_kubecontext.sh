#!/bin/bash

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
    sudo echo "$kc" | tee ~/.local/bin/kcc.sh
    echo "kubecontext script was added."
}

update_kubecontext
add_kc