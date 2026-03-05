data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# Optional: lookup an existing VPC when create_vpc=false
data "aws_vpc" "existing" {
  count = var.create_vpc ? 0 : 1
  id    = var.existing_vpc_id
}