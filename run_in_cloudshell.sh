#!/bin/bash

git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install
tfenv use 1.12.2

cd ~/injection-demo/terraform
terraform init
terraform apply --auto-approve
cd ~/
echo "Please wait 60 seconds for the EC2 instances to finish provisioning"
sleep 60 #wait for the EC2s to be ready to accept SSH connections
