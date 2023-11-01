terraform {
  required_version = "~> 1.6.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "snipe-vpc"
  cidr = "205.0.0.0/22"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["205.0.0.0/24", "205.0.1.0/24"]
  public_subnets  = ["205.0.2.0/24", "205.0.3.0/24"]


  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "web_server" {
  name        = "web_server"
  description = "Allow HTTP, HTTPS, SSH inbound traffic from an specific ip"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP to VPC from one address"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${var.whitelist_ip}/32"]
  }

  ingress {
    description = "HTTPS to VPC from one address"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["${var.whitelist_ip}/32"]
  }

  ingress {
    description = "SSH to VPC from one address"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.whitelist_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}


resource "aws_security_group" "database" {
  name        = "database"
  description = "Allow port ${var.db_port} for db connections from inner subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Database port to VPC from subnets"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "TCP"
    cidr_blocks = [module.vpc.private_subnets_cidr_blocks[0], module.vpc.public_subnets_cidr_blocks[0]]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "database-sg"
  }
}

resource "aws_db_subnet_group" "db" {
  name = "main"
  // ever for single-az need to provide multiple subnets
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  tags = {
    Name = "My DB subnet group"
  }
}