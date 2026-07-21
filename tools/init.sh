#!/bin/bash

token=$1
action=$2
rm -rf .terraform ;
git pull ;
terraform init --backend-config=env/test/state.tfvars ;
terraform plan --var-file=env/test/test.tfvars -var vault_token=$token ; 
# terraform $action -auto-approve  --var-file=env/test/test.tfvars -var vault_token=$token