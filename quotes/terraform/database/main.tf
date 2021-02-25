provider "aws" {
  region = "us-east-2"
  skip_credentials_validation = var.skip_credentials_validation
  skip_requesting_account_id = var.skip_requesting_account_id

  endpoints {
    dynamodb = var.dynamodb_endpoint
  }
}
