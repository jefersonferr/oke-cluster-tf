<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_core_security_list.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the security list. | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | OCID of the VCN. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for the resource. | `map(string)` | `null` | no |
| <a name="input_egress_security_rules"></a> [egress\_security\_rules](#input\_egress\_security\_rules) | List of egress security rules. | <pre>list(object({<br/>    protocol         = string<br/>    destination      = string<br/>    destination_type = string<br/>    description      = optional(string)<br/>    stateless        = optional(bool)<br/>    tcp_min          = optional(number)<br/>    tcp_max          = optional(number)<br/>    udp_min          = optional(number)<br/>    udp_max          = optional(number)<br/>    icmp_type        = optional(number)<br/>    icmp_code        = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for the resource. | `map(string)` | `null` | no |
| <a name="input_ingress_security_rules"></a> [ingress\_security\_rules](#input\_ingress\_security\_rules) | List of ingress security rules. | <pre>list(object({<br/>    protocol     = string<br/>    source       = string<br/>    source_type  = string<br/>    description  = optional(string)<br/>    stateless    = optional(bool)<br/>    tcp_min      = optional(number)<br/>    tcp_max      = optional(number)<br/>    udp_min      = optional(number)<br/>    udp_max      = optional(number)<br/>    icmp_type    = optional(number)<br/>    icmp_code    = optional(number)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_list_id"></a> [security\_list\_id](#output\_security\_list\_id) | n/a |
<!-- END_TF_DOCS -->