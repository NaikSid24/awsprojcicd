variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "dynamodb_table_name" {
  description = "name of the dynamo DB table for CICD"
  type        = string
  default = "ci_cd_table"
}

variable "sns_topic_arn" {
  description = "SNS topic for CICD"
  type        = string
  default = "arn:aws:sns:us-east-1:778815816015:cicd_sns_topic"
}