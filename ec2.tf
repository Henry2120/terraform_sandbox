resource "aws_instance" "public_instance" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [module.security_group.public_sg_id]

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted    = true
    volume_size  = 8
    volume_type  = "gp3"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # Enforces IMDSv2
    http_put_response_hop_limit = 1           # Restricts metadata hops
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name  # Attach the IAM instance profile here

  tags = {
    Name = "PublicInstance"
  }
}

resource "aws_instance" "private_instance" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [module.security_group.private_sg_id]

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted    = true
    volume_size  = 8
    volume_type  = "gp3"
  }

  metadata_options {
    http_endpoint               = "enabled"    # Keep the metadata service available
    http_tokens                 = "required"   # Enforce IMDSv2 by requiring tokens
    http_put_response_hop_limit = 1            # Restrict metadata requests to one network hop
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name  # Attach the IAM instance profile here

  tags = {
    Name = "PrivateInstance"
  }
}
