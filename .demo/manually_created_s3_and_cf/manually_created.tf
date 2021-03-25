// This TF stack is used to simulate that some resources in `static_website` stack
// were already created manually in the AWS account.

provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

locals {
  s3_website_origin_id        = "S3-static-website"
  bucket_regional_domain_name = "static-website-640847388391.s3.eu-central-1.amazonaws.com"
}

// create s3 resources in static_website to save time during demo

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
    domain_name = local.bucket_regional_domain_name
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
