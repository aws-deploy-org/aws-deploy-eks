variable "region" {
  description = "AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"

}

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