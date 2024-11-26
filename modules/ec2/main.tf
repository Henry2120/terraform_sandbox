resource "aws_instance" "public_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  tags                   = { Name = var.public_instance_name }
  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  # Example of an additional EBS volume with encryption
  ebs_block_device {
    device_name = "/dev/xvdf"  # Adjust as needed
    volume_size = 20           # Specify the size in GB
    encrypted   = true
  }
}

resource "aws_instance" "private_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  tags                   = { Name = var.public_instance_name }

  # Enable detailed monitoring
  monitoring             = true

  # Enable EBS optimization
  ebs_optimized          = true

  # Configure metadata options to enforce IMDSv2
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  # Configure root block device with encryption
  root_block_device {
    encrypted = true
  }

  # Example of an additional EBS volume with encryption
  ebs_block_device {
    device_name = "/dev/xvdf"  # Adjust as needed
    volume_size = 20           # Specify the size in GB
    encrypted   = true
  }
}
