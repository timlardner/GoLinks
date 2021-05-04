terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.3"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "tftest"
  hash_key = "shortcode"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "shortcode"
    type = "S"
  }
}

data "aws_iam_policy" "DynamoRead" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role" "iam_for_read" {
  name = "iam_for_read"

assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamo-read-attach" {
  role       = aws_iam_role.iam_for_read.name
  policy_arn = data.aws_iam_policy.DynamoRead.arn
}

data "archive_file" "zipit" {
  type        = "zip"
  source_file = "pylib/read.py"
  output_path = "payload-lambda-read.zip"
}

resource "aws_lambda_function" "tftest" {
  filename      = "payload-lambda-read.zip"
  function_name = "tftest-read"
  role          = aws_iam_role.iam_for_read.arn
  handler       = "read.lambda_handler"
  runtime = "python3.8"
}
