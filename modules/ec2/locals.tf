locals {
  get_instance_ip = var.internal ? aws_instance.main.private_ip : aws_instance.main.public_ip
  # get_ssh_user = data.vault_generic_secret.ssh_cred.data["ssh_user"]
  # get_ssh_pass = data.vault_generic_secret.ssh_cred.data["ssh_pass"]
}