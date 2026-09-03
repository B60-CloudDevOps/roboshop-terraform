output "subnet_ids" {
  value = aws_subnet.main[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.main[*].id
}
