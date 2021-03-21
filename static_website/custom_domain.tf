variable "website_domain" {
  type    = string
  default = "terraform-backup.cosee.biz"
}

// ACM issued certificate for TLS
module "acm_request_certificate" {
  providers = {
    aws = aws.virginia
  }

  source  = "cloudposse/acm-request-certificate/aws"
  version = "0.13.1"

  domain_name                       = var.website_domain
  process_domain_validation_options = true
  ttl                               = "30"
}

// DNS record for our domain
data "aws_route53_zone" "zone" {
  name = var.website_domain
}

resource "aws_route53_record" "website" {
  name    = var.website_domain
  type    = "A"
  zone_id = data.aws_route53_zone.zone.id

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

output "website_domains" {
  value = aws_cloudfront_distribution.website.aliases
}
