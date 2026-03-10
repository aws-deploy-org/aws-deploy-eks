locals {
  vpc_id = var.create_vpc ? aws_vpc.lz_aws_vpc[0].id : null

  # Central tag pattern (resource-level tags can still override via per-resource inputs)
  base_tags = var.tags
}