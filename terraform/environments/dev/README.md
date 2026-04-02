<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3"></a> [s3](#module\_s3) | ../s3-storage | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to all resources. | `map(string)` | <pre>{<br/>  "Environment": "dev",<br/>  "Project": "AWS-Landing-Zone"<br/>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (dev/stage/prod) | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_s3_buckets"></a> [s3\_buckets](#input\_s3\_buckets) | Map of S3 bucket configurations | <pre>map(object({<br/>    bucket_name          = string<br/>    versioning_enabled   = optional(bool, true)<br/>    enable_encryption    = optional(bool, true)<br/>    kms_key_id           = optional(string)<br/>    force_destroy        = optional(bool, false)<br/>    block_public_access  = optional(bool, true)<br/><br/>    lifecycle_rules = optional(list(object({<br/>      id      = string<br/>      enabled = bool<br/><br/>      transition = optional(list(object({<br/>        days          = number<br/>        storage_class = string<br/>      })))<br/><br/>      expiration = optional(object({<br/>        days = number<br/>      }))<br/>    })), [])<br/><br/>    logging = optional(object({<br/>      target_bucket = string<br/>      target_prefix = string<br/>    }))<br/><br/>    website = optional(object({<br/>      index_document = string<br/>      error_document = string<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->