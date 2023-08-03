provider "aws" {
  region = var.region

  default_tags {
    tags = {
      user        = "jujhar.singh@thoughtworks.com"
      application = "dms-lab-destination"
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-state-dms-lab-destination"

  // This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production usage
  force_destroy = true
}

# Enable versioning so you can see the full revision history of the state files
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// in case you have to delete manually:
// AWS_DEFAULT_REGION=eu-west-1 aws dynamodb delete-table --table-name tf-state-lock-dms-lab-destination
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "tf-state-lock-dms-lab-destination"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
