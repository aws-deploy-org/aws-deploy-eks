terraform {
  cloud {

    organization = "Terraform-IaC-Deployments"

    workspaces {
      name = "lz-infra-dev"
    }
  }


  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Provider configuration - credentials come from HCP workspace
provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      var.common_tags,
      var.tags,
      {
        Workspace = terraform.workspace
      }
    )
  }
}
