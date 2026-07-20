#!/bin/bash

action=$1
environment=$2
token=$3
rm -rf .terraform ;
terraform init --backend-config=env/${environment}/state.tfvars ;
terraform plan --var-file=env/${environment}/${environment}.tfvars  -var vault_token=${token} ;
terraform $action -auto-approve --var-file=env/${environment}/${environment}.tfvars -var vault_token=${token}