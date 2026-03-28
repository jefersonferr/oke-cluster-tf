<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_route_table.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the route table will be created. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Name of the route table. | `string` | n/a | yes |
| <a name="input_route_rules"></a> [route\_rules](#input\_route\_rules) | List of route rules to apply. | <pre>list(object({<br/>    network_entity_id = string<br/>    destination       = string<br/>    destination_type  = string<br/>    description       = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | OCID of the VCN to associate with the route table. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags. | `map(any)` | `null` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The OCID of the route table. |
<!-- END_TF_DOCS -->