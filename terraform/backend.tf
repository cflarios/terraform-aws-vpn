# Backend configuration for Terraform state
# Specific values are configured dynamically via -backend-config
terraform {
  backend "s3" {
    # Dummy values - completely overridden with -backend-config
    bucket = "dummy-bucket"
    key    = "dummy-key"
    region = "us-east-1"
  }
}
