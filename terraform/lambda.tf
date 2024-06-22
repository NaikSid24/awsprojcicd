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

resource "aws_lambda_function" "cicd_lambda" {
    function_name = "cicd_lambda"
    role = aws_iam_role.lambda_role.arn
    handler = "index.handler"
    runtime = "python3.8"
    filename = "lamda_function.zip"

    environment {
        variables = {
            DYNAMODB_TABLE = aws_dynamodb_table.ci_cd_table.name
            SNS_TOPIC = aws_sns_topic.cicd_sns_topic.arn
        }
    }
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
    role = aws_iam_role.lambda_role.arn
    policy_arn = "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"
  
}
