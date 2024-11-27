module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
  availability_zone    = "us-east-1a"
  vpc_name             = "MainVPC"
  public_subnet_name   = "PublicSubnet"
  private_subnet_name  = "PrivateSubnet"
  igw_name             = "InternetGateway"
  public_rt_name       = "PublicRouteTable"
}


module "nat_gateway" {
  source          = "./modules/nat_gateway"
  public_subnet_id = module.vpc.public_subnet_id
  vpc_id           = module.vpc.vpc_id
  nat_gw_name      = "NATGateway"
  private_rt_name  = "PrivateRouteTable"
}

module "security_group" {
  source           = "./modules/security_group"
  vpc_id           = module.vpc.vpc_id
  ssh_allowed_ip   = "116.102.222.84/32"
  public_sg_name   = "PublicEC2SG"
  private_sg_name  = "PrivateEC2SG"
}

module "ec2" {
  source              = "./modules/ec2"
  ami                 = "ami-0866a3c8686eaeeba"
  instance_type       = "t2.micro"
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  security_group_id   = module.security_group.public_sg_id
  public_instance_name = "PublicEC2Instance"
  private_instance_name = "PrivateEC2Instance"
  ec2_instance_profile_name = aws_iam_instance_profile.ec2_instance_profile.name  # Pass the IAM instance profile here
}
