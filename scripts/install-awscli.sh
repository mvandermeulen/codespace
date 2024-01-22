#!/bin/sh

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

USERNAME=${USERNAME:-"dev"}
HOME=${HOME:-"/home/$USERNAME"}
INSTALL_PATH=${INSTALL_PATH:-"/home/$USERNAME/.installed"}


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o $INSTALL_PATH/awscliv2.zip \
  && chmod 755 $INSTALL_PATH/awscliv2.zip \
  && unzip $INSTALL_PATH/awscliv2.zip -d $INSTALL_PATH/awscli \
  && sudo $INSTALL_PATH/awscli/aws/install

#AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo bash -c "./aws/install"
# Don't forget to run `aws configure` later to create ~/.aws/credentials.
# To do a quick sanity check,`aws sts --profile <yourprofile> get-caller-identity`

exit 0