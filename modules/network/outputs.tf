output "subnet_ids" {
  description = "Map of subnet group name (e.g. public, eks_private, db_private) to its list of subnet IDs, ordered to match var.availability_zones."
  value = merge(
    { for name, subnet in module.public_subnets : name => subnet.subnet_ids },
    { for name, subnet in module.private_subnets : name => subnet.subnet_ids },
  )
}
