resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "roboshop-${var.env}-vpc"
  }
}

module "subnets" {
  for_each = var.subnets

  source             = "./subnets"
  name               = each.key
  cidr_block         = each.value["cidr"]
  env                = var.env
  vpc_id             = aws_vpc.main.id
  availability_zones = var.availability_zones
  map_public_ip      = try(each.value["map_public_ip"], false)
  igw_id             = aws_internet_gateway.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-${var.env}-igw"
  }
}