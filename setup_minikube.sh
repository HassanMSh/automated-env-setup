#!/bin/bash

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

minikube_install