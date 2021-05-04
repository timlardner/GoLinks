# Package code for deploy
data "archive_file" "zipread" {
  type        = "zip"
  source_file = "pylib/read.py"
  output_path = "payload-lambda-read.zip"
}

data "archive_file" "ziplist" {
  type        = "zip"
  source_file = "pylib/list.py"
  output_path = "payload-lambda-list.zip"
}

data "archive_file" "zipcreate" {
  type        = "zip"
  source_file = "pylib/create.py"
  output_path = "payload-lambda-create.zip"
}

data "archive_file" "zipwrite" {
  type        = "zip"
  source_file = "pylib/write.py"
  output_path = "payload-lambda-write.zip"
}

resource "aws_lambda_function" "tftest-read" {
  filename      = "payload-lambda-read.zip"
  function_name = "tftest-read"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "read.lambda_handler"
  runtime = "python3.8"
}

# Define actual functions

resource "aws_lambda_function" "tftest-list" {
  filename      = "payload-lambda-list.zip"
  function_name = "tftest-list"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "list.lambda_handler"
  runtime = "python3.8"
}

resource "aws_lambda_function" "tftest-write" {
  filename      = "payload-lambda-write.zip"
  function_name = "tftest-write"
  role          = aws_iam_role.iam_for_write.arn
  handler       = "write.lambda_handler"
  runtime = "python3.8"
}

resource "aws_lambda_function" "tftest-create" {
  filename      = "payload-lambda-create.zip"
  function_name = "tftest-create"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "create.lambda_handler"
  runtime = "python3.8"
}
