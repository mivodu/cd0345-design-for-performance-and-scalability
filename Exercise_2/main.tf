provider "aws" {
  region = var.aws_region
  shared_credentials_files = ["C:/Users/Michael.Volkmann2/.aws/credentials"] 
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda.zip"
}


resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/greeting_lambda"
  retention_in_days = 1
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}  

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda_tf.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function" "greeting_lambda" {
  function_name    = "greet_lambda"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "greet_lambda.lambda_handler"
  runtime          = "python3.7"

  environment {
    variables = {
      greeting = "Hello World "
    }
  }
}
