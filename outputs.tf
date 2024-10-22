output "public_instance_ip" {
  description = "Public EC2 Instance IP"
  value       = aws_instance.public_instance.public_ip
}

output "private_instance_id" {
  description = "Private EC2 Instance ID"
  value       = aws_instance.private_instance.id
}
