resource "aws_dynamodb_table" "ci_cd_table" {
    name = "ci_cd_table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "ID"

    attribute {
      name = "ID"
      type = "S"
    }
}

