module "ec2" {
  for_each = var.tools

  source           = "../modules/ec2/"
  env_name         = var.env_name # This is how we supply the value to the module, we can use any variable or hardcoded value here
  ami_name         = var.ami_name
  sg_name          = var.sg_name
  name             = each.key
  instance_type    = each.value["instance_type"]
  root_volume_size = each.value["root_volume_size"]
  domain_name      = var.domain_name
  internal         = each.value["internal"]
  vault_token      = var.vault_token
}