resource "aws_cognito_user_pool" "user_pool" {
    name = "cici_user_pool"  

    password_policy {
      minimum_length = 8
      require_lowercase = true
      require_numbers = true
      require_symbols = true
      require_uppercase = true
    }
    mfa_configuration = "OPTIONAL"

    sms_configuration {
    external_id = random_id.external_id.hex 
    sns_caller_arn = aws_iam_role.cognito_sns_role.arn
  }


    schema {
      name = "email"
      attribute_data_type = "String"
      required = true
      mutable = false   
    }

    schema {
    name = "phone_number"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }
    verification_message_template {
      default_email_option = "CONFIRM_WITH_CODE"
      email_message = "Your verification code is {####}"
      email_subject = "Verification Code"
}
alias_attributes = ["email"]
}


resource "aws_iam_role" "cognito_sns_role" {
  name = "cognito_sns_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "sns_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "sns:Publish"
          ],
          Resource = "*"
        }
      ]
    })
  }
}


resource "aws_iam_role_policy_attachment" "cognito_sns_role_attachment" {
  role       = aws_iam_role.cognito_sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}