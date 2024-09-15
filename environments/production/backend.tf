terraform {
  backend "s3" {
    bucket         = "saas-tf-state-production"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "saas-tf-lock-production"
    encrypt        = true
  }
}
