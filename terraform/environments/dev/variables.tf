variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default = {
    Project     = "AWS-Landing-Zone"
    Environment = "dev"
  }

}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}

#S3 Buckets to create
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment (dev/stage/prod)"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "s3_buckets" {
  description = "Map of S3 bucket configurations"

  type = map(object({
    bucket_name          = string
    versioning_enabled   = optional(bool, true)
    enable_encryption    = optional(bool, true)
    kms_key_id           = optional(string)
    force_destroy        = optional(bool, false)
    block_public_access  = optional(bool, true)

    lifecycle_rules = optional(list(object({
      id      = string
      enabled = bool

      transition = optional(list(object({
        days          = number
        storage_class = string
      })))

      expiration = optional(object({
        days = number
      }))
    })), [])

    logging = optional(object({
      target_bucket = string
      target_prefix = string
    }))

    website = optional(object({
      index_document = string
      error_document = string
    }))
  }))
}
