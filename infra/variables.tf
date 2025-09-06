variable "endpoint_url" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the Lambda"
}

variable "route_table_id" {
  type        = string
  description = "Route Table ID for the Lambda"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the Lambda"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for the Lambda"
}
