# Create S3 bucket for Terraform Remote backend. S3 Bucket names MUST be unique.
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_s3_bucket
}


# Enable versioning so we can see the full revision history of our state files
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}


# Create DynamoDB resource for Terraform State Locks
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


# Configure Terraform remote backend
# terraform {
#   backend "s3" {
#     bucket         = "kuta-terraform-bucket"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }