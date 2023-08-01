vpc_name               = "dms-lab-source"
vpc_azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_enable_nat_gateway = true
ami                    = "ami-0dacb0c129b49f529"
vpc_tags = {
  source = "https://github.com/jujhars13/lab-aws-dms"
}