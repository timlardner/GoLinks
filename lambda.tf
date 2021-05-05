# Package code for deploy
data "archive_file" "zip" {
  type        = "zip"
  source_dir = "pylib/"
  output_path = "payload-lambda.zip"
}

# Define actual functions
resource "aws_lambda_function" "golink-read-tf" {
  filename      = "payload-lambda.zip"
  function_name = "golink-read-tf"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "read.lambda_handler"
  runtime = "python3.8"
  source_code_hash = data.archive_file.zip.output_sha
}

resource "aws_lambda_function" "golink-list-tf" {
  filename      = "payload-lambda.zip"
  function_name = "golink-list-tf"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "list.lambda_handler"
  runtime = "python3.8"
  source_code_hash = data.archive_file.zip.output_sha
}

resource "aws_lambda_function" "golink-write-tf" {
  filename      = "payload-lambda.zip"
  function_name = "golink-write-tf"
  role          = aws_iam_role.iam_for_write.arn
  handler       = "write.lambda_handler"
  runtime = "python3.8"
  source_code_hash = data.archive_file.zip.output_sha
}

resource "aws_lambda_function" "golink-create-tf" {
  filename      = "payload-lambda.zip"
  function_name = "golink-create-tf"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "create.lambda_handler"
  runtime = "python3.8"
  source_code_hash = data.archive_file.zip.output_sha
}
