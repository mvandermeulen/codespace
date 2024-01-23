#!/bin/bash

info() {
    echo -n "install Visual Studio Code"
}

run() {
    # import VSCode GPG key
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    
    # import RPM repository
    printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee /etc/yum.repos.d/vscode.repo
    
    sudo dnf install code -yq
}
