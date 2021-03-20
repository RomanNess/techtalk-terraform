terraform {
  backend "s3" {
    bucket  = "techtalk-terraform-remote-state-640847388391"
    encrypt = "true"
    key     = "terraform/lambda.tfstate"
    region  = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}
