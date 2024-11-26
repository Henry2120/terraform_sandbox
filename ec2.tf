resource "aws_instance" "public_instance" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [module.security_group.public_sg_id]

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted = true
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = "PublicInstance" }
}

resource "aws_instance" "private_instance" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [module.security_group.private_sg_id]

  monitoring    = true
  ebs_optimized = true

  root_block_device {
    encrypted = true
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = "PrivateInstance" }
}
