module "vpc" {
  source = "./modules/vpc"
  vpc = {
    cidr_block = "10.0.0.0/16"
    #  azs        = ["us-east-1a", "us-east-1b", "us-east-1c"]
    #   public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    #  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    tags = { environment = "dev" }
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
