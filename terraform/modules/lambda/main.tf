# Package the Lambda source code directory into a zip file


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_path
  output_path = "${path.module}/build/${var.lambda_function_name}.zip"
  
  depends_on = [null_resource.create_build_dir]
}


resource "aws_lambda_function" "generate_presigned_url" {
  function_name = var.lambda_function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout     = var.timeout
  memory_size = var.memory_size
  environment {
    variables = var.environment
  }

  tags = var.tags

  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  count = var.api_gateway_arn != null ? 1 : 0
  
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_presigned_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_arn}/*/*"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "s3:GetBucketLocation"
    ]
    resources = [
      var.bucket_arn
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3_put_policy" {
  name   = "${var.lambda_function_name}-s3-put-policy"
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
}


resource "null_resource" "create_build_dir" {
  provisioner "local-exec" {
    command = "if not exist \"${path.module}\\build\" mkdir \"${path.module}\\build\""
  }

  triggers = {
    always_run = timestamp()
  }
}


data "aws_iam_policy_document" "lambda_dlq_policy" {
  count = var.enable_dlq ? 1 : 0
  
  statement {
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.lambda_dlq.arn
    ]
  }
}

resource "aws_iam_role_policy" "lambda_dlq_policy" {
  count = var.enable_dlq ? 1 : 0
  
  name   = "${var.lambda_function_name}-dlq-policy"
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_dlq_policy[0].json
}


resource "aws_sqs_queue" "lambda_dlq" {
  name = "${var.lambda_function_name}-dlq"
  
  message_retention_seconds = 1209600  # 14 days
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.log_retention_days
  
  tags = var.tags
}
