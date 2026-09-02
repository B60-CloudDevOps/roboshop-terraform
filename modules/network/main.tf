resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "roboshop-${var.env}-vpc"
  }
}

module "subnets" {
  for_each = var.availability_zones

  source             = "./subnets"
  cidr_block         = each.value["cidr"]
  env                = var.env
  vpc_id             = aws_vpc.main.id
  availability_zones = var.availability_zones
}
