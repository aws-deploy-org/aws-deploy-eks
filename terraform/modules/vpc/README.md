# lz-nw-vpc
A module to deploy vpc and related resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.lz_aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.lz_aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.lz_aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.lz_aws_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.lz_aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.lz_aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.lz_aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.lz_aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Whether to create an Internet Gateway. | `bool` | `true` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Whether to create a new VPC. | `bool` | `true` | no |
| <a name="input_eips"></a> [eips](#input\_eips) | Map of aws\_eip resources to create. | <pre>map(object({<br/>    # Both are exposed due to documentation differences; set only one.<br/>    vpc    = optional(bool)<br/>    domain = optional(string)<br/><br/>    address                  = optional(string)<br/>    public_ipv4_pool         = optional(string)<br/>    customer_owned_ipv4_pool = optional(string)<br/>    ipam_pool_id             = optional(string)<br/>    network_border_group     = optional(string)<br/><br/>    instance          = optional(string)<br/>    network_interface = optional(string)<br/><br/>    associate_with_private_ip = optional(string)<br/><br/>    tags = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_internet_gateway"></a> [internet\_gateway](#input\_internet\_gateway) | aws\_internet\_gateway arguments. | <pre>object({<br/>    vpc_id = optional(string)<br/>    tags   = optional(map(string))<br/>  })</pre> | `{}` | no |
| <a name="input_nat_gateways"></a> [nat\_gateways](#input\_nat\_gateways) | Map of aws\_nat\_gateway resources to create. | <pre>map(object({<br/>    allocation_id = optional(string)<br/>    eip_key       = optional(string) # convenience reference to var.eips key<br/><br/>    connectivity_type = optional(string)<br/>    private_ip        = optional(string)<br/><br/>    subnet_id  = optional(string)<br/>    subnet_key = optional(string) # convenience reference to var.subnets key<br/><br/>    tags = optional(map(string))<br/><br/>    availability_mode    = optional(string)<br/>    availability_zone    = optional(string)<br/>    availability_zone_id = optional(string)<br/><br/>    secondary_allocation_ids           = optional(list(string))<br/>    secondary_private_ip_address_count = optional(number)<br/>    secondary_private_ip_addresses     = optional(list(string))<br/><br/>    availability_zone_address = optional(list(object({<br/>      allocation_id        = optional(string)<br/>      private_ip           = optional(string)<br/>      network_border_group = optional(string)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_route_table_associations"></a> [route\_table\_associations](#input\_route\_table\_associations) | Map of aws\_route\_table\_association resources to create. | <pre>map(object({<br/>    route_table_id  = optional(string)<br/>    route_table_key = optional(string) # convenience reference to var.route_tables key<br/><br/>    subnet_id  = optional(string)<br/>    subnet_key = optional(string) # convenience reference to var.subnets key<br/><br/>    gateway_id = optional(string)<br/><br/>    region = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Map of aws\_route\_table resources to create. | <pre>map(object({<br/>    vpc_id = optional(string)<br/><br/>    # Inline route blocks (do not use with aws_route for the same RT)<br/>    route = optional(list(object({<br/>      cidr_block                 = optional(string)<br/>      ipv6_cidr_block            = optional(string)<br/>      destination_prefix_list_id = optional(string)<br/><br/>      egress_only_gateway_id    = optional(string)<br/>      gateway_id                = optional(string)<br/>      instance_id               = optional(string)<br/>      nat_gateway_id            = optional(string)<br/>      local_gateway_id          = optional(string)<br/>      network_interface_id      = optional(string)<br/>      transit_gateway_id        = optional(string)<br/>      vpc_endpoint_id           = optional(string)<br/>      vpc_peering_connection_id = optional(string)<br/>    })), [])<br/><br/>    propagating_vgws = optional(list(string))<br/><br/>    tags = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of aws\_route resources to create. | <pre>map(object({<br/>    route_table_id  = optional(string)<br/>    route_table_key = optional(string) # convenience reference to var.route_tables key<br/><br/>    destination_cidr_block      = optional(string)<br/>    destination_ipv6_cidr_block = optional(string)<br/>    destination_prefix_list_id  = optional(string)<br/><br/>    carrier_gateway_id = optional(string)<br/>    core_network_arn   = optional(string)<br/><br/>    egress_only_gateway_id = optional(string)<br/>    gateway_id             = optional(string)<br/><br/>    igw_ref = optional(bool) # if true, uses module IGW id<br/><br/>    instance_id     = optional(string)<br/>    nat_gateway_id  = optional(string)<br/>    nat_gateway_key = optional(string)<br/><br/>    local_gateway_id          = optional(string)<br/>    network_interface_id      = optional(string)<br/>    transit_gateway_id        = optional(string)<br/>    vpc_endpoint_id           = optional(string)<br/>    vpc_peering_connection_id = optional(string)<br/><br/>    region = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of aws\_subnet resources to create. | <pre>map(object({<br/>    vpc_id = optional(string)<br/><br/>    cidr_block      = optional(string)<br/>    ipv6_cidr_block = optional(string)<br/><br/>    availability_zone    = optional(string)<br/>    availability_zone_id = optional(string)<br/><br/>    assign_ipv6_address_on_creation = optional(bool)<br/>    map_public_ip_on_launch         = optional(bool)<br/><br/>    outpost_arn = optional(string)<br/><br/>    tags = optional(map(string))<br/><br/>    enable_dns64 = optional(bool)<br/><br/>    enable_resource_name_dns_a_record_on_launch    = optional(bool)<br/>    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)<br/><br/>    ipv6_native = optional(bool)<br/><br/>    ipv4_ipam_pool_id   = optional(string)<br/>    ipv4_netmask_length = optional(number)<br/><br/>    ipv6_ipam_pool_id   = optional(string)<br/>    ipv6_netmask_length = optional(number)<br/><br/>    map_customer_owned_ip_on_launch = optional(bool)<br/>    customer_owned_ipv4_pool        = optional(string)<br/><br/>    private_dns_hostname_type_on_launch = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Base tags applied via per-resource inputs. | `map(string)` | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | aws\_vpc arguments. | <pre>object({<br/>    cidr_block       = string<br/>    instance_tenancy = optional(string)<br/><br/>    enable_dns_support   = optional(bool)<br/>    enable_dns_hostnames = optional(bool)<br/><br/>    assign_generated_ipv6_cidr_block = optional(bool)<br/><br/>    ipv4_ipam_pool_id   = optional(string)<br/>    ipv4_netmask_length = optional(number)<br/><br/>    ipv6_cidr_block     = optional(string)<br/>    ipv6_ipam_pool_id   = optional(string)<br/>    ipv6_netmask_length = optional(number)<br/><br/>    ipv6_cidr_block_network_border_group = optional(string)<br/><br/>    enable_network_address_usage_metrics = optional(bool)<br/><br/>    tags = optional(map(string))<br/><br/>    region = optional(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eips"></a> [eips](#output\_eips) | Elastic IP attributes. |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | Internet Gateway attributes (null if not created). |
| <a name="output_nat_gateways"></a> [nat\_gateways](#output\_nat\_gateways) | NAT Gateway attributes. |
| <a name="output_route_table_associations"></a> [route\_table\_associations](#output\_route\_table\_associations) | Route table association attributes. |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Route table attributes. |
| <a name="output_routes"></a> [routes](#output\_routes) | Route attributes. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Subnet attributes. |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | VPC attributes. |
<!-- END_TF_DOCS -->