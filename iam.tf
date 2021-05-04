# Allow API gateway to invoke all of our lambda functions

resource "aws_lambda_permission" "apigw_lambda_read" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tftest-read.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.tftest.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_write" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tftest-write.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.tftest.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_list" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tftest-list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.tftest.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_create" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tftest-create.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.tftest.execution_arn}/*/*/*"
}

# Create roles for our lambda functions and attach a Dynamo DB policy to each of them
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

resource "aws_iam_role" "iam_for_write" {
  name = "iam_for_write"

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

data "aws_iam_policy" "DynamoRead" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

data "aws_iam_policy" "DynamoWrite" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamo-read-attach" {
  role       = aws_iam_role.iam_for_read.name
  policy_arn = data.aws_iam_policy.DynamoRead.arn
}

resource "aws_iam_role_policy_attachment" "dynamo-write-attach" {
  role       = aws_iam_role.iam_for_write.name
  policy_arn = data.aws_iam_policy.DynamoWrite.arn
}

