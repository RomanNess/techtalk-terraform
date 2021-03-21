locals {
  s3_website_origin_id = "S3-static-website-640847388391"
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

    // authentication with basic-auth
    lambda_function_association {
      event_type   = "viewer-request"
      include_body = false
      lambda_arn   = data.aws_cloudformation_stack.basic_auth_lambda.outputs.LambdaQualifiedArn
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
    acm_certificate_arn = module.acm_request_certificate.arn
    ssl_support_method  = "sni-only"
  }

  default_root_object = "index.html"
  is_ipv6_enabled     = true

  aliases = [
    var.website_domain
  ]
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}

data "aws_cloudformation_stack" "basic_auth_lambda" {
  provider = aws.virginia

  name = "basicAuthLambda2"
}