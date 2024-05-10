#!/bin/bash

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
        "gitlab"
        "bitnami"
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
        "https://charts.gitlab.io/"
        "https://charts.bitnami.com/bitnami"
    )
    
    # Loop through the array and download Helm repos
    for ((i=0; i<${#helm_repo_names[@]}; i++))
    do
        repo_name="${helm_repo_names[$i]}"
        repo_url="${helm_repo_urls[$i]}"
        
        # Adding Helm repository using 'helm repo add'
        helm3 repo add "$repo_name" "$repo_url"
        
        # list the repositories to verify if it was added correctly
        helm3 repo list | grep "$repo_name"
    
    done
    
    helm3 repo update
    echo "Helm repos were succesfully added"

    helm3 plugin install https://github.com/helm/helm-mapkubeapis
    echo "Helm plugin mapkubeapis was succesfully installed"
}

helm_repo_add
