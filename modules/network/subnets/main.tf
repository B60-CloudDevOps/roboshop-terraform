locals {
  availability_zones = [
    for az in var.availability_zones : substr(az, -2, 2)
  ]
}

resource "aws_subnet" "main" {
  count             = length(var.cidr_block)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    Name = "roboshop-${var.env}-${var.name}-subnet-${local.availability_zones[count.index % length(local.availability_zones)]}"
  }
}