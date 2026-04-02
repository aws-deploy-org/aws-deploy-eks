locals {
  common_tags = merge(
    {
      ManagedBy = "Terraform"
      Module    = "s3-storage"
    },
    var.tags
  )
}
