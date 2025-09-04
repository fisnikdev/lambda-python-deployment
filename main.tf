provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"
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
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "example" {
  function_name = "my-lambda-function"
  handler       = "app.lambda_handler" # Updated handler for Python
  runtime       = "python3.9"         # Use a supported Python runtime
  role          = aws_iam_role.lambda_role.arn
  filename      = "python_lambda.zip"  # Updated ZIP file
  source_code_hash = filebase64sha256("python_lambda.zip")
}
