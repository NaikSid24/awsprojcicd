resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "lambda_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Effect = "Allow",
        Action = [
          "dynamodb:*",
          "sns:*"
        ],
        Resource = "*"
      }]
    })
  }
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
    role  = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}
resource "aws_lambda_function" "cicd_lambda" {
    function_name = "cicd_lambda"
    role = aws_iam_role.lambda_role.arn
    handler = "lambda_function.handler"
    runtime = "python3.8"
    filename = "${path.module}/../code/lambda_function.zip"

    environment {
        variables = {
            DYNAMODB_TABLE = var.dynamodb_table_name
            SNS_TOPIC = var.sns_topic_arn
        }
    }
}


