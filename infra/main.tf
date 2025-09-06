provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "local"
  region = "us-east-1"
  endpoints {
    dynamodb = var.endpoint_url
  }
}

module "dynamodb_table" {
  count  = var.endpoint_url != "" ? 0 : 1
  source = "./modules/dynamodb-table"
  providers = {
    aws = aws
  }
}

module "dynamodb_table_local" {
  count  = var.endpoint_url != "" ? 1 : 0
  source = "./modules/dynamodb-table"
  providers = {
    aws = aws.local
  }
}