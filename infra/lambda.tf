resource "aws_iam_role" "lambda_exec_role" {
  count = var.endpoint_url != "" ? 0 : 1

  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "dynamodb_rw_policy" {
  count       = var.endpoint_url != "" ? 0 : 1
  name        = "dynamodb-rw-policy"
  description = "Allow Lambda to read/write items in rfid-log-table"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = module.dynamodb_table[0].table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_vpc_policy" {
  role = aws_iam_role.lambda_exec_role[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AttachNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  count      = var.endpoint_url != "" ? 0 : 1
  role       = aws_iam_role.lambda_exec_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  count      = var.endpoint_url != "" ? 0 : 1
  role       = aws_iam_role.lambda_exec_role[0].name
  policy_arn = aws_iam_policy.dynamodb_rw_policy[0].arn
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  service_name      = "com.amazonaws.us-east-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  vpc_id            = var.vpc_id
  route_table_ids   = [var.route_table_id]
}

resource "aws_lambda_function" "rfid_handler" {
  count = var.endpoint_url != "" ? 0 : 1

  function_name = "rfid-tap-handler"
  role          = aws_iam_role.lambda_exec_role[0].arn

  filename         = "${path.module}/../app/build/libs/app-all.jar"
  source_code_hash = filebase64sha256("${path.module}/../app/build/libs/app-all.jar")

  handler = "backend.rfid.iot.TapHandler::handleRequest"
  runtime = "java21"
  timeout = 30

  vpc_config {
    subnet_ids         = [var.subnet_id]
    security_group_ids = [var.security_group_id]
  }
}