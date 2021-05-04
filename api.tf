resource "aws_apigatewayv2_api" "tftest" {
  name                       = "tftest"
  protocol_type              = "HTTP"
}

resource "aws_apigatewayv2_domain_name" "tftest-domain" {
  domain_name = "golinks.intae.it"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.issued.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_deployment" "deployment" {
  api_id      = aws_apigatewayv2_api.tftest.id
  description = "Deployment"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_apigatewayv2_route.read,
    aws_apigatewayv2_route.list,
    aws_apigatewayv2_route.create,
    aws_apigatewayv2_route.write
  ]
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.tftest.id
  name   = "$default"
  deployment_id = aws_apigatewayv2_deployment.deployment.id
}

resource "aws_apigatewayv2_api_mapping" "mapping" {
  api_id      = aws_apigatewayv2_api.tftest.id
  domain_name = aws_apigatewayv2_domain_name.tftest-domain.id
  stage       = aws_apigatewayv2_stage.default.id
}


resource "aws_apigatewayv2_integration" "tftest-read" {
  api_id           = aws_apigatewayv2_api.tftest.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.tftest-read.invoke_arn

  response_parameters {
    status_code = 302
    mappings = {
      "overwrite:header.Location" = "$response.body"
    }
  }
}

resource "aws_apigatewayv2_integration" "tftest-list" {
  api_id           = aws_apigatewayv2_api.tftest.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.tftest-list.invoke_arn
}

resource "aws_apigatewayv2_integration" "tftest-create" {
  api_id           = aws_apigatewayv2_api.tftest.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.tftest-create.invoke_arn
}

resource "aws_apigatewayv2_integration" "tftest-write" {
  api_id           = aws_apigatewayv2_api.tftest.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.tftest-write.invoke_arn

  request_parameters = {
    "overwrite:querystring.body" = "$request.body"
  }
}

resource "aws_apigatewayv2_route" "read" {
  api_id    = aws_apigatewayv2_api.tftest.id
  route_key = "GET $default"
  target = "integrations/${aws_apigatewayv2_integration.tftest-read.id}"
}

resource "aws_apigatewayv2_route" "write" {
  api_id    = aws_apigatewayv2_api.tftest.id
  route_key = "POST /create"
  target = "integrations/${aws_apigatewayv2_integration.tftest-write.id}"
}

resource "aws_apigatewayv2_route" "create" {
  api_id    = aws_apigatewayv2_api.tftest.id
  route_key = "GET /create"
  target = "integrations/${aws_apigatewayv2_integration.tftest-create.id}"
}

resource "aws_apigatewayv2_route" "list" {
  api_id    = aws_apigatewayv2_api.tftest.id
  route_key = "GET /list"
  target = "integrations/${aws_apigatewayv2_integration.tftest-list.id}"
}

