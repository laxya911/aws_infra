# --- Remote Backend Configuration ---
# Store the state file in S3 for team collaboration and locking.
# 1. Create an S3 bucket (e.g., "my-terraform-state-bucket").
# 2. Create a DynamoDB table (e.g., "terraform-lock-table") with Partition Key "LockID".
# 3. Uncomment the block below and replace values.

/*
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "devops/infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
*/
