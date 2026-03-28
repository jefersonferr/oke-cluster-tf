<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_vcn.vcn](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_vcn) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where resource will be created | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The user-friendly name for the VCN | `string` | n/a | yes |
| <a name="input_dns_label"></a> [dns\_label](#input\_dns\_label) | DNS label for the VCN (max 15 characters, alphanumeric) | `string` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The IPv4 CIDR block for the VCN | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vcn_cidr_block"></a> [vcn\_cidr\_block](#output\_vcn\_cidr\_block) | n/a |
| <a name="output_vcn_default_route_table_id"></a> [vcn\_default\_route\_table\_id](#output\_vcn\_default\_route\_table\_id) | n/a |
| <a name="output_vcn_default_security_list_id"></a> [vcn\_default\_security\_list\_id](#output\_vcn\_default\_security\_list\_id) | n/a |
| <a name="output_vcn_display_name"></a> [vcn\_display\_name](#output\_vcn\_display\_name) | n/a |
| <a name="output_vcn_dns_label"></a> [vcn\_dns\_label](#output\_vcn\_dns\_label) | n/a |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | n/a |
<!-- END_TF_DOCS -->