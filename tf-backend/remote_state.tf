provider "aws" {
  region              = "eu-central-1"
  allowed_account_ids = [640847388391]
}

data "aws_caller_identity" "current" {}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

// s3 bucket that will be used for terraform remote state in next steps
resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "techtalk-terraform-remote-state-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = data.aws_kms_alias.s3.arn
      }
    }
  }

  tags = {
    stage     = "nostage"
    stack     = "tf-backend"
    managedby = "terraform"
  }
}

output "remote_state_bucket_arn" {
  value = aws_s3_bucket.terraform_remote_state.arn
}
