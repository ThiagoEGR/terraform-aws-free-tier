data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "app_lambda" {
  filename      = data.archive_file.lambda_package.output_path
  function_name = "app_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  runtime = "nodejs20.x"
}
