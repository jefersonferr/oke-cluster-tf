<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_default_route_table.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_default_route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_route_table_id"></a> [default\_route\_table\_id](#input\_default\_route\_table\_id) | OCID of the default route table for the VCN. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the default route table. | `string` | n/a | yes |
| <a name="input_route_rules"></a> [route\_rules](#input\_route\_rules) | List of route rules to configure in the default route table. | <pre>list(object({<br/>    network_entity_id = string<br/>    destination       = string<br/>    destination_type  = string<br/>    description       = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for the route table. | `map(any)` | `null` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for the route table. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The OCID of the default route table. |
<!-- END_TF_DOCS -->