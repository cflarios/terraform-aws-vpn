# Backend configuration for Terraform state
# Los valores específicos se configuran dinámicamente via -backend-config
terraform {
  backend "s3" {
    # Valores dummy - se sobrescriben completamente con -backend-config
    bucket = "dummy-bucket"
    key    = "dummy-key"
    region = "us-east-1"
  }
}
