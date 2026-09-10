resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "roboshop-${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-${var.env}-igw"
  }
}

module "public_subnets" {
  for_each = { for name, subnet in var.subnets : name => subnet if try(subnet["map_public_ip"], false) }

  source             = "./subnets"
  name               = each.key
  cidr_block         = each.value["cidr"]
  env                = var.env
  vpc_id             = aws_vpc.main.id
  availability_zones = var.availability_zones
  map_public_ip      = true
  igw_id             = aws_internet_gateway.main.id
}

locals {
  nat_gateway_ids = flatten([for subnet in module.public_subnets : subnet.nat_gateway_ids])
}

locals {
  route_table_ids = flatten(concat(
    [for subnet in module.public_subnets : subnet.route_table_ids],
    [for subnet in module.private_subnets : subnet.route_table_ids]
  ))
}

module "private_subnets" {
  for_each = { for name, subnet in var.subnets : name => subnet if !try(subnet["map_public_ip"], false) }

  source             = "./subnets"
  name               = each.key
  cidr_block         = each.value["cidr"]
  env                = var.env
  vpc_id             = aws_vpc.main.id
  availability_zones = var.availability_zones
  map_public_ip      = false
  igw_id             = aws_internet_gateway.main.id
  use_nat_gateway    = try(each.value["ngw"], false)
  nat_gateway_ids    = local.nat_gateway_ids
}

# Adding peering connections for VPCs defined in the peering_vpcs variable
resource "aws_vpc_peering_connection" "peering" {
  for_each = var.peering_vpcs

  vpc_id      = aws_vpc.main.id
  peer_vpc_id = each.value["id"]
  auto_accept = true

  tags = {
    Name = "roboshop-${var.env}-peering-${each.key}"
  }
}

# Adding routes for peering connections in the route table of the peer VPC -
resource "aws_route" "peering_routes" {
  for_each = var.peering_vpcs

  route_table_id            = each.value["routetable_id"]
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[each.key].id
}

# Adding routes for peering connections on all route tables of the roboshop VPC -
resource "aws_route" "peering_routes_roboshop" {
  for_each = {
    # Keyed by route table index (known at plan time), not the route table id itself
    # (which is unknown until apply when the route tables are being created fresh).
    for pair in setproduct(keys(var.peering_vpcs), range(length(local.route_table_ids))) :
    "${pair[0]}-${pair[1]}" => {
      peering_key     = pair[0]
      route_table_idx = pair[1]
    }
  }

  route_table_id            = local.route_table_ids[each.value["route_table_idx"]]
  destination_cidr_block    = var.peering_vpcs[each.value["peering_key"]]["cidr"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[each.value["peering_key"]].id
}
