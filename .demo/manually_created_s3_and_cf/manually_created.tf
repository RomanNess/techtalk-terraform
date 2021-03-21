// This TF stack is used to simulate that some resources in `static_website` stack
// were already created manually in the AWS account.

provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

locals {
  s3_website_origin_id = "S3-static-website-640847388391"
}

resource "aws_s3_bucket" "website" {
  bucket = "static-website-${data.aws_caller_identity.current.account_id}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  force_destroy = true
}

data "aws_iam_policy_document" "website_bucket" {
  statement {
    sid       = "PublicRead"
    principals {
      type        = "*"
      identifiers = [
        "*"
      ]
    }
    actions   = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.website.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "update_website_root_bucket_policy" {
  bucket = aws_s3_bucket.website.id

  policy = data.aws_iam_policy_document.website_bucket.json
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.website.bucket
  key    = "index.html"

  content_type  = "text/html"
  cache_control = "public, must-revalidate, proxy-revalidate, max-age=0"

  source = "html/index.html"
  etag = filemd5("html/index.html")
}

resource "aws_cloudfront_distribution" "website" {
  enabled = true
  default_cache_behavior {

    allowed_methods        = [
      "GET",
      "HEAD"
    ]
    cached_methods         = [
      "GET",
      "HEAD"
    ]
    target_origin_id       = local.s3_website_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.s3_website_origin_id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_root_object = "index.html"
  is_ipv6_enabled     = true
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}
