vpc_name               = "dms-lab-destination"
region                 = "eu-west-1"
vpc_azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_enable_nat_gateway = true
vpc_tags = {
  source = "https://github.com/jujhars13/lab-aws-dms"
}
vpc_cidr            = "10.0.48.0/21"
vpc_private_subnets = ["10.0.48.0/24", "10.0.49.0/24"]
vpc_public_subnets  = ["10.0.50.0/24", "10.0.51.0/24"]
