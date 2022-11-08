# TODO: Define the output variable for the lambda function.
output "greet_lambda_arn" {
  value = aws_lambda_function.greeting_lambda.arn
}
