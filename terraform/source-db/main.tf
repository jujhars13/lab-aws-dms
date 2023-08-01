provider "aws" {
  profile = "default"
  region  = var.region

    default_tags {
    tags = {
      user = "jujhar.singh@thoughtworks.com"
      application = "dms-lab-source"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

# module "ec2_instances" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "4.3.0"
#   count   = 2

#   name = "my-ec2-cluster"

#   ami                    = "ami-0c5204531f799e0c6"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [module.vpc.default_security_group_id]
#   subnet_id              = module.vpc.public_subnets[0]

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
