# VPC Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

# EC2 Outputs
output "public_ec2_ip" {
  value = module.ec2.public_instance_ip
}

output "private_ec2_id" {
  value = module.ec2.private_instance_id
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

# Security Group Outputs
output "public_sg_id" {
  value = module.security_group.public_sg_id
}

output "private_sg_id" {
  value = module.security_group.private_sg_id
}