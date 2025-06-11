data "aws_region" "current" {}

# REST API
resource "aws_api_gateway_rest_api" "document_upload_api" {
  name        = var.api_name
  description = "API for generating presigned URLs for document uploads"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# /generate-presigned-url Resource
resource "aws_api_gateway_resource" "presigned_url_resource" {
  rest_api_id = aws_api_gateway_rest_api.document_upload_api.id
  parent_id   = aws_api_gateway_rest_api.document_upload_api.root_resource_id
  path_part   = "generate-presigned-url"
}

# POST Method (Lambda Proxy)
resource "aws_api_gateway_method" "presigned_url_method" {
  rest_api_id   = aws_api_gateway_rest_api.document_upload_api.id
  resource_id   = aws_api_gateway_resource.presigned_url_resource.id
  http_method   = "POST"
  authorization = var.authorization_type
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.document_upload_api.id
  resource_id             = aws_api_gateway_resource.presigned_url_resource.id
  http_method             = aws_api_gateway_method.presigned_url_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}

# CORS OPTIONS Method
resource "aws_api_gateway_method" "presigned_url_options" {
  rest_api_id   = aws_api_gateway_rest_api.document_upload_api.id
  resource_id   = aws_api_gateway_resource.presigned_url_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "presigned_url_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.document_upload_api.id
  resource_id = aws_api_gateway_resource.presigned_url_resource.id
  http_method = aws_api_gateway_method.presigned_url_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "presigned_url_options_response" {
  rest_api_id = aws_api_gateway_rest_api.document_upload_api.id
  resource_id = aws_api_gateway_resource.presigned_url_resource.id
  http_method = aws_api_gateway_method.presigned_url_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "presigned_url_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.document_upload_api.id
  resource_id = aws_api_gateway_resource.presigned_url_resource.id
  http_method = aws_api_gateway_method.presigned_url_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.presigned_url_options_integration]
}

# Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.document_upload_api.id

  depends_on = [
    aws_api_gateway_method.presigned_url_method,
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method.presigned_url_options,
    aws_api_gateway_integration.presigned_url_options_integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Stage with optional logging
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.document_upload_api.id
  stage_name    = var.stage_name
  tags          = var.tags

  dynamic "access_log_settings" {
    for_each = var.enable_logging ? [1] : []
    content {
      destination_arn = aws_cloudwatch_log_group.api_gateway_logs[0].arn
      format = jsonencode({
        requestId      = "$context.requestId"
        ip             = "$context.identity.sourceIp"
        caller         = "$context.identity.caller"
        user           = "$context.identity.user"
        requestTime    = "$context.requestTime"
        httpMethod     = "$context.httpMethod"
        resourcePath   = "$context.resourcePath"
        status         = "$context.status"
        protocol       = "$context.protocol"
        responseLength = "$context.responseLength"
      })
    }
  }

  xray_tracing_enabled = var.enable_xray_tracing
}

# Log Group for access logging
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  count             = var.enable_logging ? 1 : 0
  name              = "/aws/apigateway/${var.api_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# Lambda permission
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.document_upload_api.execution_arn}/*/*"
}
