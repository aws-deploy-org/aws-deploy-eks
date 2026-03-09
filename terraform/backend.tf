terraform {
  # HCP Terraform Cloud backend
  cloud {
    organization = "Terraform-IaC-Deployments"  # Replace with your HCP organization name
    
    # Workspaces will be selected dynamically based on environment
    # Workspace naming convention: {project}-{resource}-{environment}
    # Example: vpc-infrastructure-dev
    workspaces {
      # Tag-based selection (optional)
      tags = ["vpc", "networking"]
      
      # Or explicit workspace name (will be set via TF_WORKSPACE env var)
      name = null  # Determined at runtime
    }
  }
  
  required_version = ">= 1.7.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
