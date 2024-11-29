terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-west-2"
}
