resource "aws_dynamodb_table" "this" {
  name         = "rfid-log-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "TagId"
  range_key = "CreatedAtEpoch"

  attribute {
    name = "TagId"
    type = "S"
  }

  attribute {
    name = "CreatedAtEpoch"
    type = "N"
  }
}

output "table_arn" {
  value = aws_dynamodb_table.this.arn
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}