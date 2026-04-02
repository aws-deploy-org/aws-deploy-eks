module "vpc" {
  source = "../../modules/vpc"
  vpc = {
    cidr_block = "10.0.0.0/16"
    tags       = { env = "dev" }
  }

  subnets = {
    public1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"

    }
    public2 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
    public3 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1c"
    }
    private1 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1a"
    }
    private2 = {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-1b"
    }
    private3 = {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-1c"
    }
  }

  nat_gateways = {
    regional = {
      availability_mode = "regional"
    }
  }

}

module "s3" {
  source = "../s3-storage"

  for_each = var.s3_buckets

  bucket_name         = each.value.bucket_name
  force_destroy       = try(each.value.force_destroy, false)
  versioning_enabled  = try(each.value.versioning_enabled, true)
  enable_encryption   = try(each.value.enable_encryption, true)
  kms_key_id          = try(each.value.kms_key_id, null)
  block_public_access = try(each.value.block_public_access, true)

  lifecycle_rules = try(each.value.lifecycle_rules, [])

  logging = try(each.value.logging, null)
  website = try(each.value.website, null)

  tags = {
    Name        = each.value.bucket_name
    Environment = var.environment
    Project     = var.project
  }
}
