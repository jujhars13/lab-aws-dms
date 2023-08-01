required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 4.49.0"
  }
}
required_version = ">= 1.5.0"
// chicken and egg - provision state bucket first
terraform {
  backend "s3" {
    bucket         = "tf-state-dms-lab-source"
    region         = "eu-west-1"
    dynamodb_table = "tf-state-lock-dms-lab-source"
    key            = "base/terraform.tfstate"
  }
}
