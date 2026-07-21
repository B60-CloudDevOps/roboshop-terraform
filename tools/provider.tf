# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "b60-s3-for-tfstate"
    key    = "tools/tools-env/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "vault" {
  address         = "http://vault-tools.robotshop.fun:8200"
  token           = var.vault_token
  skip_tls_verify = true
}