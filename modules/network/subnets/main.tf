locals {
  availability_zones = [
    for az in var.availability_zones : substr(az, -2, 2)
  ]
}

resource "aws_subnet" "main" {
  count                   = length(var.cidr_block)
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block[count.index]
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = "roboshop-${var.env}-${var.name}-subnet-${local.availability_zones[count.index % length(local.availability_zones)]}"
  }
}

resource "aws_route_table" "main" {
  count = length(var.cidr_block)

  vpc_id = var.vpc_id

  tags = {
    Name = "roboshop-${var.env}-${var.name}-route-table-${local.availability_zones[count.index % length(local.availability_zones)]}"
  }
}

resource "aws_route_table_association" "main" {
  count          = length(var.cidr_block)
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main[count.index].id
}

resource "aws_route" "igw-route" {
  count                  = var.map_public_ip ? length(var.cidr_block) : 0
  route_table_id         = aws_route_table.main[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}