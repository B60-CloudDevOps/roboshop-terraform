module "vpc" {
  for_each = var.vpc

  source             = "./modules/network"
  vault_token        = var.vault_token
  vpc_cidr           = each.value["vpc_cidr"]
  env                = var.env
  availability_zones = each.value["availability_zones"]
  subnets            = each.value["subnets"]
  peering_vpcs       = try(each.value["peering_vpcs"], {})
}

module "ec2" {
  for_each = var.components
  depends_on = [module.vpc]

  source           = "./modules/ec2"
  env_name         = var.env_name # This is how we supply the value to the module, we can use any variable or hardcoded value here
  ami_name         = var.ami_name
  sg_name          = var.sg_name
  name             = each.key
  instance_type    = each.value["instance_type"]
  root_volume_size = each.value["root_volume_size"]
  domain_name      = var.domain_name
  internal         = each.value["internal"]
  vault_token      = var.vault_token
  iam_policy       = try(each.value["iam_policy"], [])
  # Databases live in the db_private subnet, AZ 1a (first entry, matches availability_zones[0])
  subnet_id        = module.vpc["main"].subnet_ids["db_private"][0]
}

module "eks" {
  depends_on = [module.ec2]

  source                  = "./modules/eks"
  cluster_name            = var.cluster_name
  env                     = var.env
  eks_version             = var.eks_version
  # EKS cluster/nodes spread across eks_private subnets in both 1a and 1b
  subnet_ids              = module.vpc["main"].subnet_ids["eks_private"]
  node_group_desired_size = var.node_group_desired_size
  node_group_max_size     = var.node_group_max_size
  node_group_min_size     = var.node_group_min_size
  instance_types          = var.instance_types
}
