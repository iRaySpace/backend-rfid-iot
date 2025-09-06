resource "aws_dynamodb_table" "rfid_log_table" {
  name         = "rfid-log-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "TagID"
  range_key = "CreatedAt"

  attribute {
    name = "TagID"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "S"
  }
}
