<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_containerengine_node_pool.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/containerengine_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_name"></a> [ad\_name](#input\_ad\_name) | The Availability Domain where the worker nodes will be deployed | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where the node pool will be created | `string` | n/a | yes |
| <a name="input_node_image_id"></a> [node\_image\_id](#input\_node\_image\_id) | The OCID of the image used by OKE worker nodes | `string` | n/a | yes |
| <a name="input_node_pool_name"></a> [node\_pool\_name](#input\_node\_pool\_name) | The display name of the node pool | `string` | n/a | yes |
| <a name="input_node_subnet_id"></a> [node\_subnet\_id](#input\_node\_subnet\_id) | The OCID of the subnet for worker nodes | `string` | n/a | yes |
| <a name="input_oke_cluster_id"></a> [oke\_cluster\_id](#input\_oke\_cluster\_id) | The OCID of the OKE cluster | `string` | n/a | yes |
| <a name="input_boot_volume_size_in_gbs"></a> [boot\_volume\_size\_in\_gbs](#input\_boot\_volume\_size\_in\_gbs) | The boot volume size in GBs for each worker node | `number` | `50` | no |
| <a name="input_cni_type"></a> [cni\_type](#input\_cni\_type) | The CNI plugin type: FLANNEL or OCI\_VCN\_IP\_NATIVE | `string` | `"OCI_VCN_IP_NATIVE"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version for the worker nodes | `string` | `"v1.34.2"` | no |
| <a name="input_memory_in_gbs"></a> [memory\_in\_gbs](#input\_memory\_in\_gbs) | The amount of memory in GBs per worker node (used with Flex shapes) | `number` | `16` | no |
| <a name="input_node_shape"></a> [node\_shape](#input\_node\_shape) | The compute shape for worker nodes. Flex shapes allow custom OCPU and memory. | `string` | `"VM.Standard.E5.Flex"` | no |
| <a name="input_ocpus"></a> [ocpus](#input\_ocpus) | The number of OCPUs per worker node (used with Flex shapes) | `number` | `2` | no |
| <a name="input_pod_subnet_ids"></a> [pod\_subnet\_ids](#input\_pod\_subnet\_ids) | A list of subnet OCIDs for native pod networking. Required for OCI\_VCN\_IP\_NATIVE, empty for FLANNEL. | `list(string)` | `[]` | no |
| <a name="input_size"></a> [size](#input\_size) | The number of worker nodes in the node pool | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_pool_id"></a> [node\_pool\_id](#output\_node\_pool\_id) | O OCID do Node Pool |
<!-- END_TF_DOCS -->