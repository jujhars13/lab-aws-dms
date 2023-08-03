terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
  required_version = ">= 1.5.0"
  // chicken and egg - provision state bucket first

  backend "s3" {
    bucket         = "tf-state-dms-lab-destination"
    region         = "eu-west-1"
    dynamodb_table = "tf-state-lock-dms-lab-destination"
    key            = "base/terraform.tfstate"
    encrypt        = true
  }
}
