#!/bin/bash

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

install_golang