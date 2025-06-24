#!/bin/bash

git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install
tfenv use 1.12.2

git clone https://github.com/scotti-fletcher/injection-demo
cd injection-demo/terraform
terraform init
terraform apply --auto-approve
export WEBSERVER_IP=$(terraform output -raw webserver_public_ip)
export ATTACKER_IP=$(terraform output -raw attacker_public_ip)
cd ~/
ssh -i ~/lab_key.pem ubuntu@$WEBSERVER_IP
