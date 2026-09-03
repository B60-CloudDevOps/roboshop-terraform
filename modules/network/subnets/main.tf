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

resource "aws_eip" "nat" {
  count  = var.map_public_ip ? length(var.cidr_block) : 0
  domain = "vpc"

  tags = {
    Name = "roboshop-${var.env}-${var.name}-nat-eip-${local.availability_zones[count.index % length(local.availability_zones)]}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.map_public_ip ? length(var.cidr_block) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.main[count.index].id

  tags = {
    Name = "roboshop-${var.env}-${var.name}-nat-${local.availability_zones[count.index % length(local.availability_zones)]}"
  }

  depends_on = [aws_route.igw-route]
}

resource "aws_route" "ngw-route" {
  count                  = var.use_nat_gateway ? length(var.cidr_block) : 0
  route_table_id         = aws_route_table.main[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index % length(var.nat_gateway_ids)]
}