vpc_name               = "dms-lab-source"
region                 = "eu-west-1"
vpc_azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_enable_nat_gateway = true
ec2_ami                = "ami-05a3d90809a151346" // 2023-08-01 eu-west-1 Amazon Linux x86
vpc_tags = {
  source = "https://github.com/jujhars13/lab-aws-dms"
}