prefix                 = "dms-lab-source"
vpc_name               = "dms-lab-source"
region                 = "eu-west-1"
vpc_azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_enable_nat_gateway = true
vpc_cidr               = "10.0.0.0/21"
vpc_private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]
project_tags = {
  Source      = "https://github.com/jujhars13/lab-aws-dms"
  Terraform   = "true"
  Environment = "dev"
  User        = "jujhar.singh@thoughtworks.com"
  Application = "dms-lab-source"
}
