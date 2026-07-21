# Configure the AWS Provider
provider "aws" {}

provider "vault" {
  address         = "http://vault-tools.robotshop.fun:8200"
  token           = var.vault_token
  skip_tls_verify = true
}