provider "aws" {
  region = "us-east-1"  # Chọn region phù hợp
}

# Tạo VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}

# Tạo Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "PublicSubnet"
  }
}

# Tạo Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PrivateSubnet"
  }
}

# Tạo Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "InternetGateway"
  }
}

# Tạo NAT Gateway
resource "aws_eip" "nat_eip" {
  # Sử dụng Elastic IP cho NAT Gateway
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NATGateway"
  }
}

# Tạo Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Liên kết Public Route Table với Public Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Tạo Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Liên kết Private Route Table với Private Subnet
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Tạo Default Security Group
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["116.102.222.84/32"]  # IP cho phép SSH (Thay đổi địa chỉ ip thành địa chỉ ip public của máy)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PublicEC2SG"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]  # Cho phép truy cập từ Public EC2 SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateEC2SG"
  }
}

# Tạo EC2 Instance Public
resource "aws_instance" "public_instance" {
  ami               = "ami-0866a3c8686eaeeba"  
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]  # Sử dụng vpc_security_group_ids

  tags = {
    Name = "PublicInstance"
  }
}

# Tạo EC2 Instance Private
resource "aws_instance" "private_instance" {
  ami               = "ami-0866a3c8686eaeeba" 
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]  # Sử dụng vpc_security_group_ids

  tags = {
    Name = "PrivateInstance"
  }
}
