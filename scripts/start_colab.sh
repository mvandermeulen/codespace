#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}

wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
pip install jupyter_kernel_gateway
pip install torch -f https://download.pytorch.org/whl/cu113/torch_stable.html
pip install torchdata
pip install portalocker
pip install 'ludwig[full]'
# jupyter server password --generate-config
# echo "c.NotebookApp.password = u'sha1:${NOTEBOOK_PASSWORD}">>/root/.jupyter/jupyter_notebook_config.py
ngrok config add-authtoken ${NGROK_API_TOKEN}
jupyter kernelgateway --KernelGatewayApp.allow_credentials='*' --KernelGatewayApp.allow_headers='*' --KernelGatewayApp.allow_methods='*' --KernelGatewayApp.allow_origin='*' --KernelGatewayApp.auth_token=${KERNEL_GATEWAY_TOKEN} --NotebookHTTPPersonality.allow_notebook_download='True' --JupyterWebsocketPersonality.list_kernels='True' && \
    ngrok http --domain=colab.ngrok.dev 8888

exit 0