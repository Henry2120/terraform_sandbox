output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "private_rt_id" {
  value = aws_route_table.private_rt.id
}
