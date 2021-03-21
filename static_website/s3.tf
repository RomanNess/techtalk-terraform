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
