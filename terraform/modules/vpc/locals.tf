locals {
  vpc_id = var.create_vpc ? aws_vpc.this[0].id : data.aws_vpc.existing[0].id

  # Central tag pattern (resource-level tags can still override via per-resource inputs)
  base_tags = var.tags
}