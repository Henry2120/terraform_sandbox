resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Ensure that the EIP is for VPC use
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id  # Associate the EIP with the NAT Gateway
  subnet_id     = var.public_subnet_id
  tags = { Name = var.nat_gw_name }
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = var.private_rt_name }
}
