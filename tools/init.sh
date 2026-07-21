#!/bin/bash

token=$1
rm -rf .terraform ;
git pull ;
terraform init ;
terraform plan -var vault_token=$token ; 
terraform apply -auto-approve -var vault_token=$token