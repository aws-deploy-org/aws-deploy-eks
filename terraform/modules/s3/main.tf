resource "aws_s3_bucket" "this" {
  bucket        = "lz-${var.environment}-s3-${var.bucket_name}"
  force_destroy = var.force_destroy

  tags = local.common_tags
}

# Ownership Controls (Required Best Practice)
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.block_public_access ? 1 : 0

  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = var.kms_key_id != null ? "aws:kms" : "AES256"
    }
  }
}

# Lifecycle Rules
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "transition" {
        for_each = try(rule.value.transition, [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = try([rule.value.expiration], [])
        content {
          days = expiration.value.days
        }
      }
    }
  }
}

# Logging
resource "aws_s3_bucket_logging" "this" {
  count = var.logging != null ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix
}

# Website Hosting
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.website != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.website.index_document
  }

  error_document {
    key = var.website.error_document
  }
}
