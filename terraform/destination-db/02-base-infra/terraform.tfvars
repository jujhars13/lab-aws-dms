vpc_name               = "dms-lab-destination"
region                 = "eu-west-1"
vpc_azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_enable_nat_gateway = true
vpc_tags = {
  source = "https://github.com/jujhars13/lab-aws-dms"
}
