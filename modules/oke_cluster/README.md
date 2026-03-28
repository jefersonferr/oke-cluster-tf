<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_containerengine_cluster.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/containerengine_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where the cluster will be created | `string` | n/a | yes |
| <a name="input_endpoint_subnet_id"></a> [endpoint\_subnet\_id](#input\_endpoint\_subnet\_id) | The OCID of the subnet for the Kubernetes API endpoint | `string` | n/a | yes |
| <a name="input_service_lb_subnet_ids"></a> [service\_lb\_subnet\_ids](#input\_service\_lb\_subnet\_ids) | A list of OCIDs for the subnets where the load balancers will be created | `list(string)` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | The OCID of the VCN for the cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The display name of the OKE cluster | `string` | `"oke-cluster"` | no |
| <a name="input_cni_type"></a> [cni\_type](#input\_cni\_type) | The CNI plugin type for the cluster: FLANNEL or OCI\_VCN\_IP\_NATIVE | `string` | `"OCI_VCN_IP_NATIVE"` | no |
| <a name="input_is_public_ip_enabled"></a> [is\_public\_ip\_enabled](#input\_is\_public\_ip\_enabled) | Whether the Kubernetes API endpoint should be public (true) or private (false) | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version for the cluster control plane | `string` | `"v1.34.2"` | no |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | The CIDR block for Kubernetes ClusterIP services | `string` | `"10.96.0.0/16"` | no |
| <a name="input_type_of_cluster"></a> [type\_of\_cluster](#input\_type\_of\_cluster) | Type of cluster OKE: BASIC\_CLUSTER or ENHANCED\_CLUSTER | `string` | `"ENHANCED_CLUSTER"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Cluster OKE id |
<!-- END_TF_DOCS -->