# Example 2 — Flannel CNI, Private Kubernetes API Endpoint
# Reference: https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-flannel-cni-privatek8sapi_privateworkers_publiclb

region         = "sa-saopaulo-1"
compartment_id = "ocid1.compartment.oc1..example"
ad_name        = "xxxx:SA-SAOPAULO-1-AD-1"
cluster_name   = "oke-flannel-private"

cni_type               = "FLANNEL"
is_api_endpoint_public = false
type_of_cluster        = "ENHANCED_CLUSTER"

vcn_cidr_block_16        = "10.0.0.0/16"
subnet_lb_cidr_24        = "10.0.0.0/24"
subnet_api_endpoint_cidr = "10.0.1.0/30"
subnet_nodes_cidr_24     = "10.0.2.0/24"

kubernetes_version = "v1.34.2"
pool_size          = 2
pool_node_shape    = "VM.Standard.E6.Flex"
pool_node_image_id = "ocid1.image.oc1.sa-saopaulo-1.example"
ocpus              = 2
memory_in_gbs      = 16