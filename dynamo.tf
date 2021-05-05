resource "aws_dynamodb_table" "link-table" {
  name = local.json_data.TABLE
  hash_key = "shortcode"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "shortcode"
    type = "S"
  }
}
