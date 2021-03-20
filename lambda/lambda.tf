data "archive_file" "main_zip" {
  type        = "zip"
  source_file = "${path.module}/main.js"
  output_path = "${path.module}/build/main.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "terraform"

  filename = data.archive_file.main_zip.output_path
  source_code_hash = data.archive_file.main_zip.output_base64sha256

  handler = "main.handler"
  runtime = "nodejs10.x"

  role = aws_iam_role.lambda.arn
}
