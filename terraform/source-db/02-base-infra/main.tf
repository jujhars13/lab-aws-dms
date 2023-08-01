provider "aws" {
  region = var.region

  default_tags {
    tags = {
      user        = "jujhar.singh@thoughtworks.com"
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

// get latest x86 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"] # amazon
}

# Allow all outbound connections
resource "aws_security_group" "bastion" {
  vpc_id      = module.vpc.id
  name        = "bastion"
  description = "Security group for bastion"

}

resource "aws_security_group_rule" "bastion-egresss" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}


module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
  count   = 1

  name = "lab-aws-dms-bastion-host"

  ami                         = aws_ami.amazon_linux_2
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.aws_security_group.bastion.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  provisioner "remote-exec" {
    script = "${path.module}/provision-source-bastion.sh"
  }
}
