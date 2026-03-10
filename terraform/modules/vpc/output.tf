output "vpc" {
  description = "VPC attributes."
  value = var.create_vpc ? {
    id                        = aws_vpc.lz_aws_vpc[0].id
    arn                       = aws_vpc.lz_aws_vpc[0].arn
    cidr_block                = aws_vpc.lz_aws_vpc[0].cidr_block
    main_route_table_id       = aws_vpc.lz_aws_vpc[0].main_route_table_id
    default_security_group_id = aws_vpc.lz_aws_vpc[0].default_security_group_id
    default_route_table_id    = aws_vpc.lz_aws_vpc[0].default_route_table_id
    owner_id                  = aws_vpc.lz_aws_vpc[0].owner_id
    tags_all                  = aws_vpc.lz_aws_vpc[0].tags_all
  } : null
}

output "subnets" {
  description = "Subnet attributes."
  value = var.create_vpc ? {
    for k, s in aws_subnet.lz_aws_subnet : k => {
      id         = s.id
      arn        = s.arn
      owner_id   = s.owner_id
      tags_all   = s.tags_all
      cidr_block = s.cidr_block
    }
  } : null
}


output "internet_gateway" {
  description = "Internet Gateway attributes (null if not created)."
  value = var.create_internet_gateway ? {
    id       = aws_internet_gateway.lz_aws_internet_gateway[0].id
    arn      = aws_internet_gateway.lz_aws_internet_gateway[0].arn
    owner_id = aws_internet_gateway.lz_aws_internet_gateway[0].owner_id
    tags_all = aws_internet_gateway.lz_aws_internet_gateway[0].tags_all
  } : null
}

output "eips" {
  description = "Elastic IP attributes."
  value = {
    for k, e in aws_eip.lz_aws_eip : k => {
      id                = e.id
      allocation_id     = e.allocation_id
      association_id    = e.association_id
      private_ip        = e.private_ip
      private_dns       = e.private_dns
      public_ip         = e.public_ip
      public_dns        = e.public_dns
      instance          = e.instance
      network_interface = e.network_interface
      tags_all          = e.tags_all
    }
  }
}

output "nat_gateways" {
  description = "NAT Gateway attributes."
  value = {
    for k, n in aws_nat_gateway.lz_aws_nat_gateway : k => {
      id                           = n.id
      allocation_id                = n.allocation_id
      association_id               = n.association_id
      network_interface_id         = n.network_interface_id
      private_ip                   = n.private_ip
      public_ip                    = n.public_ip
      subnet_id                    = n.subnet_id
      tags_all                     = n.tags_all
      regional_nat_gateway_address = n.regional_nat_gateway_address
    }
  }
}

output "route_tables" {
  description = "Route table attributes."
  value = {
    for k, rt in aws_route_table.lz_aws_route_table : k => {
      id       = rt.id
      arn      = rt.arn
      owner_id = rt.owner_id
      tags_all = rt.tags_all
    }
  }
}

output "routes" {
  description = "Route attributes."
  value = {
    for k, r in aws_route.lz_aws_route : k => {
      id                = r.id
      instance_id       = r.instance_id
      instance_owner_id = r.instance_owner_id
    }
  }
}

output "route_table_associations" {
  description = "Route table association attributes."
  value = {
    for k, a in aws_route_table_association.lz_aws_route_table_association : k => {
      id = a.id
    }
  }
}