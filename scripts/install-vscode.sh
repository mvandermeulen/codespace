#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}


curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo bash -c "apt install apt-transport-https"
sudo bash -c "apt update -y"
sudo bash -c "apt install code"
echo -e "export DOTNET_CLI_TELEMETRY_OPTOUT=1" >> ~/.bashrc
source ~/.bashrc

# VS Code Server
curl -fsSL https://aka.ms/install-vscode-server/setup.sh | sh
code-server --install-extension ms-python.python
code-server --install-extension ms-toolsai.jupyter
code-server --install-extension ms-python.vscode-pylance
code-server --install-extension ms-azuretools.vscode-docker
code-server --install-extension ms-vscode-remote.remote-containers
code-server --install-extension ms-vscode-remote.remote-ssh
code-server --install-extension ms-vscode-remote.remote-ssh-edit
code-server --install-extension ms-vscode-remote.remote-wsl
code-server --install-extension ms-vscode-remote.vscode-remote-extensionpack

# VS Code CLI with Tunnel Service
curl https://az764295.vo.msecnd.net/stable/b3e4e68a0bc097f0ae7907b217c1119af9e03435/vscode_cli_alpine_x64_cli.tar.gz | tar -zxvf -C /usr/local/bin
# Create a systemd service file for vs code tunnel
cat << EOF > /etc/systemd/system/code-tunnel.service
[Unit]
Description=VS Code Tunnel Service
[Service]
Type=simple
ExecStart=/usr/local/bin/code tunnel
User=$1
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable code-tunnel.service

# Start the service immediately
systemctl start code-tunnel.service


exit 0