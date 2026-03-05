variable "tags" {
  description = "Base tags applied via per-resource inputs."
  type        = map(string)
  default     = {}
}

variable "create_vpc" {
  description = "Whether to create a new VPC."
  type        = bool
  default     = true
}

variable "existing_vpc_id" {
  description = "Existing VPC ID when create_vpc=false."
  type        = string
  default     = null
}

variable "vpc" {
  description = "aws_vpc arguments."
  type = object({
    cidr_block       = string
    instance_tenancy = optional(string)

    enable_dns_support   = optional(bool)
    enable_dns_hostnames = optional(bool)

    assign_generated_ipv6_cidr_block = optional(bool)

    ipv4_ipam_pool_id   = optional(string)
    ipv4_netmask_length = optional(number)

    ipv6_cidr_block     = optional(string)
    ipv6_ipam_pool_id   = optional(string)
    ipv6_netmask_length = optional(number)

    ipv6_cidr_block_network_border_group = optional(string)

    enable_network_address_usage_metrics = optional(bool)

    tags = optional(map(string))

    region = optional(string)
  })
}

variable "subnets" {
  description = "Map of aws_subnet resources to create."
  type = map(object({
    vpc_id = optional(string)

    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)

    availability_zone    = optional(string)
    availability_zone_id = optional(string)

    assign_ipv6_address_on_creation = optional(bool)
    map_public_ip_on_launch         = optional(bool)

    outpost_arn = optional(string)

    tags = optional(map(string))

    enable_dns64 = optional(bool)

    enable_resource_name_dns_a_record_on_launch     = optional(bool)
    enable_resource_name_dns_aaaa_record_on_launch  = optional(bool)

    ipv6_native = optional(bool)

    ipv4_ipam_pool_id   = optional(string)
    ipv4_netmask_length = optional(number)

    ipv6_ipam_pool_id   = optional(string)
    ipv6_netmask_length = optional(number)

    map_customer_owned_ip_on_launch = optional(bool)
    customer_owned_ipv4_pool        = optional(string)

    private_dns_hostname_type_on_launch = optional(string)
  }))
  default = {}
}

variable "create_internet_gateway" {
  description = "Whether to create an Internet Gateway."
  type        = bool
  default     = true
}

variable "internet_gateway" {
  description = "aws_internet_gateway arguments."
  type = object({
    vpc_id = optional(string)
    tags   = optional(map(string))
  })
  default = {}
}

variable "eips" {
  description = "Map of aws_eip resources to create."
  type = map(object({
    # Both are exposed due to documentation differences; set only one.
    vpc    = optional(bool)
    domain = optional(string)

    address             = optional(string)
    public_ipv4_pool     = optional(string)
    customer_owned_ipv4_pool = optional(string)
    ipam_pool_id         = optional(string)
    network_border_group = optional(string)

    instance         = optional(string)
    network_interface = optional(string)

    associate_with_private_ip = optional(string)

    tags = optional(map(string))
  }))
  default = {}
}

variable "nat_gateways" {
  description = "Map of aws_nat_gateway resources to create."
  type = map(object({
    allocation_id = optional(string)
    eip_key       = optional(string) # convenience reference to var.eips key

    connectivity_type = optional(string)
    private_ip        = optional(string)

    subnet_id  = optional(string)
    subnet_key = optional(string) # convenience reference to var.subnets key

    tags = optional(map(string))

    availability_mode    = optional(string)
    availability_zone    = optional(string)
    availability_zone_id = optional(string)

    secondary_allocation_ids           = optional(list(string))
    secondary_private_ip_address_count = optional(number)
    secondary_private_ip_addresses     = optional(list(string))

    availability_zone_address = optional(list(object({
      allocation_id       = optional(string)
      private_ip          = optional(string)
      network_border_group = optional(string)
    })), [])
  }))
  default = {}
}

variable "route_tables" {
  description = "Map of aws_route_table resources to create."
  type = map(object({
    vpc_id = optional(string)

    # Inline route blocks (do not use with aws_route for the same RT)
    route = optional(list(object({
      cidr_block                 = optional(string)
      ipv6_cidr_block            = optional(string)
      destination_prefix_list_id = optional(string)

      egress_only_gateway_id    = optional(string)
      gateway_id                = optional(string)
      instance_id               = optional(string)
      nat_gateway_id            = optional(string)
      local_gateway_id          = optional(string)
      network_interface_id      = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
    })), [])

    propagating_vgws = optional(list(string))

    tags = optional(map(string))
  }))
  default = {}
}

variable "routes" {
  description = "Map of aws_route resources to create."
  type = map(object({
    route_table_id  = optional(string)
    route_table_key = optional(string) # convenience reference to var.route_tables key

    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id  = optional(string)

    carrier_gateway_id = optional(string)
    core_network_arn    = optional(string)

    egress_only_gateway_id = optional(string)
    gateway_id             = optional(string)

    igw_ref = optional(bool) # if true, uses module IGW id

    instance_id      = optional(string)
    nat_gateway_id   = optional(string)
    nat_gateway_key  = optional(string)

    local_gateway_id          = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)

    region = optional(string)
  }))
  default = {}
}

variable "route_table_associations" {
  description = "Map of aws_route_table_association resources to create."
  type = map(object({
    route_table_id  = optional(string)
    route_table_key = optional(string) # convenience reference to var.route_tables key

    subnet_id  = optional(string)
    subnet_key = optional(string) # convenience reference to var.subnets key

    gateway_id = optional(string)

    region = optional(string)
  }))
  default = {}
}

# --- Validations (best-practice guardrails) ---

variable "validation" {
  description = "No-op variable to host cross-field validations."
  type        = object({})
  default     = {}

  validation {
    condition     = var.create_vpc || (var.existing_vpc_id != null && var.existing_vpc_id != "")
    error_message = "When create_vpc=false, existing_vpc_id must be set."
  }

  validation {
    condition = alltrue([
      for k, s in var.subnets :
      !(
        (s.availability_zone != null && s.availability_zone_id != null)
      )
    ])
    error_message = "Each subnet must set only one of availability_zone or availability_zone_id."
  }

  validation {
    condition = alltrue([
      for k, e in var.eips :
      !(
        (e.vpc != null && e.domain != null)
      )
    ])
    error_message = "Each EIP must set only one of vpc or domain."
  }

  validation {
    condition = alltrue([
      for k, r in var.routes :
      (
        # at least one destination field set
        (r.destination_cidr_block != null || r.destination_ipv6_cidr_block != null || r.destination_prefix_list_id != null)
      )
    ])
    error_message = "Each route must set a destination_* field."
  }
}