resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block = var.vpc.cidr_block

  instance_tenancy = var.vpc.instance_tenancy

  enable_dns_support   = var.vpc.enable_dns_support
  enable_dns_hostnames = var.vpc.enable_dns_hostnames

  assign_generated_ipv6_cidr_block = var.vpc.assign_generated_ipv6_cidr_block

  ipv4_ipam_pool_id    = var.vpc.ipv4_ipam_pool_id
  ipv4_netmask_length  = var.vpc.ipv4_netmask_length
  ipv6_cidr_block      = var.vpc.ipv6_cidr_block
  ipv6_ipam_pool_id    = var.vpc.ipv6_ipam_pool_id
  ipv6_netmask_length  = var.vpc.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.vpc.ipv6_cidr_block_network_border_group

  enable_network_address_usage_metrics = var.vpc.enable_network_address_usage_metrics

  tags = var.vpc.tags

  region = var.vpc.region
}

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id = coalesce(each.value.vpc_id, local.vpc_id)

  cidr_block      = each.value.cidr_block
  ipv6_cidr_block = each.value.ipv6_cidr_block

  availability_zone    = each.value.availability_zone
  availability_zone_id = each.value.availability_zone_id

  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation
  map_public_ip_on_launch         = each.value.map_public_ip_on_launch

  outpost_arn = each.value.outpost_arn

  enable_dns64                                 = each.value.enable_dns64
  enable_resource_name_dns_a_record_on_launch  = each.value.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch

  ipv6_native         = each.value.ipv6_native
  ipv4_ipam_pool_id   = each.value.ipv4_ipam_pool_id
  ipv4_netmask_length = each.value.ipv4_netmask_length
  ipv6_ipam_pool_id   = each.value.ipv6_ipam_pool_id
  ipv6_netmask_length = each.value.ipv6_netmask_length

  map_customer_owned_ip_on_launch = each.value.map_customer_owned_ip_on_launch

  # Present in docs/behavior when map_customer_owned_ip_on_launch=true (kept optional here)
  customer_owned_ipv4_pool = each.value.customer_owned_ipv4_pool

  private_dns_hostname_type_on_launch = each.value.private_dns_hostname_type_on_launch

  tags = each.value.tags
}

resource "aws_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0

  vpc_id = var.internet_gateway.vpc_id != null ? var.internet_gateway.vpc_id : local.vpc_id
  tags   = var.internet_gateway.tags
}

resource "aws_eip" "this" {
  for_each = var.eips

  # Arguments per docs (some are mutually exclusive in AWS behavior)
  vpc    = each.value.vpc
  domain = each.value.domain

  address                 = each.value.address
  public_ipv4_pool         = each.value.public_ipv4_pool
  customer_owned_ipv4_pool = each.value.customer_owned_ipv4_pool
  ipam_pool_id             = each.value.ipam_pool_id
  network_border_group     = each.value.network_border_group

  instance        = each.value.instance
  network_interface = each.value.network_interface

  associate_with_private_ip = each.value.associate_with_private_ip

  tags = each.value.tags
}

resource "aws_nat_gateway" "this" {
  for_each = var.nat_gateways

  allocation_id = each.value.allocation_id != null ? each.value.allocation_id : (
    each.value.eip_key != null ? aws_eip.this[each.value.eip_key].allocation_id : null
  )

  connectivity_type = each.value.connectivity_type
  private_ip        = each.value.private_ip

  subnet_id = each.value.subnet_id != null ? each.value.subnet_id : aws_subnet.this[each.value.subnet_key].id

  tags = each.value.tags

  availability_mode    = each.value.availability_mode
  availability_zone    = each.value.availability_zone
  availability_zone_id = each.value.availability_zone_id

  secondary_allocation_ids           = each.value.secondary_allocation_ids
  secondary_private_ip_address_count = each.value.secondary_private_ip_address_count
  secondary_private_ip_addresses     = each.value.secondary_private_ip_addresses

  dynamic "availability_zone_address" {
    for_each = each.value.availability_zone_address
    content {
      allocation_id      = availability_zone_address.value.allocation_id
      private_ip         = availability_zone_address.value.private_ip
      network_border_group = availability_zone_address.value.network_border_group
    }
  }
}

resource "aws_route_table" "this" {
  for_each = var.route_tables

  vpc_id = each.value.vpc_id != null ? each.value.vpc_id : local.vpc_id

  # NOTE: Cannot safely use both inline routes here and aws_route resources for the same route table.
  dynamic "route" {
    for_each = each.value.route
    content {
      cidr_block                 = route.value.cidr_block
      ipv6_cidr_block            = route.value.ipv6_cidr_block
      destination_prefix_list_id = route.value.destination_prefix_list_id

      egress_only_gateway_id    = route.value.egress_only_gateway_id
      gateway_id                = route.value.gateway_id
      instance_id               = route.value.instance_id
      nat_gateway_id            = route.value.nat_gateway_id
      local_gateway_id          = route.value.local_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_endpoint_id           = route.value.vpc_endpoint_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  propagating_vgws = each.value.propagating_vgws
  tags             = each.value.tags
}

resource "aws_route" "this" {
  for_each = var.routes

  route_table_id = each.value.route_table_id != null ? each.value.route_table_id : aws_route_table.this[each.value.route_table_key].id

  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id

  carrier_gateway_id = each.value.carrier_gateway_id
  core_network_arn    = each.value.core_network_arn

  egress_only_gateway_id = each.value.egress_only_gateway_id

  gateway_id = each.value.gateway_id != null ? each.value.gateway_id : (
    each.value.igw_ref == true ? aws_internet_gateway.this[0].id : null
  )

  instance_id               = each.value.instance_id
  nat_gateway_id            = each.value.nat_gateway_id != null ? each.value.nat_gateway_id : (each.value.nat_gateway_key != null ? aws_nat_gateway.this[each.value.nat_gateway_key].id : null)
  local_gateway_id          = each.value.local_gateway_id
  network_interface_id      = each.value.network_interface_id
  transit_gateway_id        = each.value.transit_gateway_id
  vpc_endpoint_id           = each.value.vpc_endpoint_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id

  region = each.value.region
}

resource "aws_route_table_association" "this" {
  for_each = var.route_table_associations

  route_table_id = each.value.route_table_id != null ? each.value.route_table_id : aws_route_table.this[each.value.route_table_key].id

  subnet_id  = each.value.subnet_id != null ? each.value.subnet_id : (each.value.subnet_key != null ? aws_subnet.this[each.value.subnet_key].id : null)
  gateway_id = each.value.gateway_id

  region = each.value.region
}