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