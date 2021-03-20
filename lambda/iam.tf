resource "aws_iam_role" "lambda" {
  name = "serverless_example_lambda"

  assume_role_policy = data.aws_iam_policy_document.lambda.json

}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "lambda.amazonaws.com"
      ]
      type        = "Service"
    }
  }
}
