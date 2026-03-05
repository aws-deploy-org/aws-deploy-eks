output "vpc" {
  description = "VPC attributes (created or existing)."
  value = var.create_vpc ? {
    id                     = aws_vpc.this[0].id
    arn                    = aws_vpc.this[0].arn
    cidr_block             = aws_vpc.this[0].cidr_block
    instance_tenancy       = aws_vpc.this[0].instance_tenancy
    enable_dns_support     = aws_vpc.this[0].enable_dns_support
    enable_dns_hostnames   = aws_vpc.this[0].enable_dns_hostnames
    main_route_table_id    = aws_vpc.this[0].main_route_table_id
    default_network_acl_id = aws_vpc.this[0].default_network_acl_id
    default_security_group_id = aws_vpc.this[0].default_security_group_id
    default_route_table_id = aws_vpc.this[0].default_route_table_id
    ipv6_association_id    = aws_vpc.this[0].ipv6_association_id
    ipv6_cidr_block        = aws_vpc.this[0].ipv6_cidr_block
    owner_id               = aws_vpc.this[0].owner_id
    tags_all               = aws_vpc.this[0].tags_all
  } : {
    id                     = data.aws_vpc.existing[0].id
    arn                    = data.aws_vpc.existing[0].arn
    cidr_block             = data.aws_vpc.existing[0].cidr_block
    instance_tenancy       = data.aws_vpc.existing[0].instance_tenancy
    enable_dns_support     = data.aws_vpc.existing[0].enable_dns_support
    enable_dns_hostnames   = data.aws_vpc.existing[0].enable_dns_hostnames
    main_route_table_id    = data.aws_vpc.existing[0].main_route_table_id
    ipv6_association_id    = data.aws_vpc.existing[0].ipv6_association_id
    ipv6_cidr_block        = data.aws_vpc.existing[0].ipv6_cidr_block
    owner_id               = data.aws_vpc.existing[0].owner_id
  }
}

output "subnets" {
  description = "Subnet attributes."
  value = {
    for k, s in aws_subnet.this : k => {
      id                           = s.id
      arn                          = s.arn
      ipv6_cidr_block_association_id = s.ipv6_cidr_block_association_id
      owner_id                     = s.owner_id
      tags_all                     = s.tags_all
      available_ip_address_count   = s.available_ip_address_count
      customer_owned_ipv4_pool     = s.customer_owned_ipv4_pool
    }
  }
}

output "internet_gateway" {
  description = "Internet Gateway attributes (null if not created)."
  value = var.create_internet_gateway ? {
    id       = aws_internet_gateway.this[0].id
    arn      = aws_internet_gateway.this[0].arn
    owner_id = aws_internet_gateway.this[0].owner_id
    tags_all = aws_internet_gateway.this[0].tags_all
  } : null
}

output "eips" {
  description = "Elastic IP attributes."
  value = {
    for k, e in aws_eip.this : k => {
      id             = e.id
      allocation_id  = e.allocation_id
      association_id = e.association_id
      private_ip     = e.private_ip
      private_dns    = e.private_dns
      public_ip      = e.public_ip
      public_dns     = e.public_dns
      instance       = e.instance
      network_interface = e.network_interface
      public_ipv4_pool  = e.public_ipv4_pool
      carrier_ip        = e.carrier_ip
      customer_owned_ip = e.customer_owned_ip
      ptr_record        = e.ptr_record
      tags_all          = e.tags_all
    }
  }
}

output "nat_gateways" {
  description = "NAT Gateway attributes."
  value = {
    for k, n in aws_nat_gateway.this : k => {
      id                    = n.id
      allocation_id         = n.allocation_id
      association_id        = n.association_id
      network_interface_id  = n.network_interface_id
      private_ip            = n.private_ip
      public_ip             = n.public_ip
      subnet_id             = n.subnet_id
      tags_all              = n.tags_all
      auto_provision_zones  = n.auto_provision_zones
      auto_scaling_ips      = n.auto_scaling_ips
      status                = n.status
      regional_nat_gateway_address = n.regional_nat_gateway_address
    }
  }
}

output "route_tables" {
  description = "Route table attributes."
  value = {
    for k, rt in aws_route_table.this : k => {
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
    for k, r in aws_route.this : k => {
      id               = r.id
      instance_id      = r.instance_id
      instance_owner_id = r.instance_owner_id
      origin           = r.origin
      state            = r.state
    }
  }
}

output "route_table_associations" {
  description = "Route table association attributes."
  value = {
    for k, a in aws_route_table_association.this : k => {
      id = a.id
    }
  }
}