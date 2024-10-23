# VPC Configuration
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

# EC2 Configuration
variable "ami" {
  default = "ami-0866a3c8686eaeeba"
}

variable "instance_type" {
  default = "t2.micro"
}

# Security Group Configuration
variable "ssh_allowed_ip" {
  description = "Allowed IP for SSH access"
  default     = "116.102.222.84/32"  
}

variable "vpc_name" {
  description = "Name of the VPC"
}