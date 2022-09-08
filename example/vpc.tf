#KNOWISSUE:Public Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.14.4"

  name = "russ-test-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # NAT GW's enabled in order to allow access to Docker Hub.
  # Shouldn't be needed if your using ECR for the images.
  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  tags = {
    Owner = "Russ W"
  }
}

resource "aws_route53_zone" "private_zone" {
  name = var.vpc_domain

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}
