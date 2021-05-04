resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "tftest"
  hash_key = "shortcode"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "shortcode"
    type = "S"
  }
}
