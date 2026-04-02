variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "enable_encryption" {
  type    = bool
  default = true
}

variable "block_public_access" {
  type    = bool
  default = true
}

variable "lifecycle_rules" {
  type = list(object({
    id      = string
    enabled = bool

    transition = optional(list(object({
      days          = number
      storage_class = string
    })))

    expiration = optional(object({
      days = number
    }))
  }))
  default = []
}

variable "logging" {
  type = object({
    target_bucket = string
    target_prefix = string
  })
  default = null
}

variable "website" {
  type = object({
    index_document = string
    error_document = string
  })
  default = null
}
