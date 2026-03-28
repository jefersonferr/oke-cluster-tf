<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_subnet.subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The IPv4 CIDR block for the subnet | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where the subnet will be created | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the subnet | `string` | n/a | yes |
| <a name="input_dns_label"></a> [dns\_label](#input\_dns\_label) | DNS label for the subnet (max 15 characters, alphanumeric) | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | The OCID of the route table associated with the subnet | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | The OCID of the VCN where the subnet will be created | `string` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | Whether to prohibit public IP assignment on VNICs in this subnet | `bool` | `false` | no |
| <a name="input_security_list_ids"></a> [security\_list\_ids](#input\_security\_list\_ids) | List of security list OCIDs associated with the subnet | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_cidr_block"></a> [subnet\_cidr\_block](#output\_subnet\_cidr\_block) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vcn_display_name"></a> [vcn\_display\_name](#output\_vcn\_display\_name) | n/a |
| <a name="output_vcn_dns_label"></a> [vcn\_dns\_label](#output\_vcn\_dns\_label) | n/a |
<!-- END_TF_DOCS -->