terraform { 
  cloud { 
    
    organization = "Terraform-IaC-Deployments" 

    workspaces { 
      name = "dev" 
    } 
  } 
}