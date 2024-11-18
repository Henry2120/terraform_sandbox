resource "aws_instance" "public_instance" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  monitoring    = true
  ebs_optimized = true

  metadata_options {
    http_tokens   = "required" # Bắt buộc sử dụng IMDSv2
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true               # Bật mã hóa volume gốc
    volume_size = 8                # Dung lượng volume (GB)
    volume_type = "gp3"            # Loại volume EBS
  }

  tags = {
    Name = "PublicInstance"
  }
}



resource "aws_instance" "private_instance" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  # Bật Detailed Monitoring
  monitoring    = true

  # Bật EBS Optimization
  ebs_optimized = true

  # Thiết lập Metadata Service để sử dụng IMDSv2
  metadata_options {
    http_tokens   = "required" # Bắt buộc sử dụng IMDSv2
    http_endpoint = "enabled"
  }

  # Mã hóa volume gốc
  root_block_device {
    encrypted = true          # Mã hóa volume gốc
    volume_size = 8           # Dung lượng volume (GB)
    volume_type = "gp3"       # Loại volume EBS
  }

  tags = {
    Name = "PrivateInstance"
  }
}
