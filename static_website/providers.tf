terraform {
  backend "s3" {
    bucket  = "techtalk-terraform-remote-state-640847388391"
    encrypt = "true"
    key     = "terraform/static-website.tfstate"
    region  = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
