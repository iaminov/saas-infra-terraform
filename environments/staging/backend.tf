terraform {
  backend "s3" {
    bucket         = "saas-tf-state-staging"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "saas-tf-lock-staging"
    encrypt        = true
  }
}
