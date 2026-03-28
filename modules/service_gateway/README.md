<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_service_gateway.service_gateway](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_service_gateway) | resource |
| [oci_core_services.all_services](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_services) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where resource will be created | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the associated resource | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | The OCID of the VCN where the resource will be created | `string` | n/a | yes |
| <a name="input_service_id"></a> [service\_id](#input\_service\_id) | Optional Oracle Service OCID. If not provided, All Services in Oracle Services Network will be used automatically. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_region_services"></a> [all\_region\_services](#output\_all\_region\_services) | n/a |
| <a name="output_service_gateway_display_name"></a> [service\_gateway\_display\_name](#output\_service\_gateway\_display\_name) | n/a |
| <a name="output_service_gateway_id"></a> [service\_gateway\_id](#output\_service\_gateway\_id) | n/a |
<!-- END_TF_DOCS -->