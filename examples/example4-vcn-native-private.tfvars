# Example 4 — OCI VCN-Native CNI, Private Kubernetes API Endpoint
# Reference: https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-oci-cni-privatek8sapi_privateworkers_publiclb

region         = "sa-saopaulo-1"
compartment_id = "ocid1.compartment.oc1..example"
ad_name        = "xxxx:SA-SAOPAULO-1-AD-1"
cluster_name   = "oke-native-private"

cni_type               = "OCI_VCN_IP_NATIVE"
is_api_endpoint_public = false
type_of_cluster        = "ENHANCED_CLUSTER"

vcn_cidr_block_16        = "10.0.0.0/16"
subnet_lb_cidr_24        = "10.0.0.0/24"
subnet_api_endpoint_cidr = "10.0.1.0/29"
subnet_nodes_cidr_24     = "10.0.2.0/24"
subnet_pods_cidr_19      = "10.0.32.0/19"

kubernetes_version = "v1.34.2"
pool_size          = 2
pool_node_shape    = "VM.Standard.E6.Flex"
pool_node_image_id = "ocid1.image.oc1.sa-saopaulo-1.example"
ocpus              = 2
memory_in_gbs      = 16