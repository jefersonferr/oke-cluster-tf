variable "region" {
  type        = string
  description = "The OCI region where resources will be created (e.g., sa-saopaulo-1)"
}

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where resource will be created"
}

variable "cluster_name" {
  type        = string
  description = "The display name of the OKE cluster"
}

variable "vcn_cidr_block_16" {
  type        = string
  description = "IPv4 CIDR /16 block for the VCN, providing 65,536 addresses (e.g., 10.0.0.0/16)"
}

variable "subnet_lb_cidr_24" {
  type        = string
  description = "IPv4 CIDR /24 block for the Load Balancer subnet, providing 256 addresses (e.g., 10.0.0.0/24)"
}

variable "subnet_api_endpoint_cidr_29" {
  type        = string
  description = "IPv4 CIDR /29 block for the Kubernetes API Endpoint subnet, providing 8 addresses (e.g., 10.0.1.0/29)"
}

variable "subnet_nodes_cidr_24" {
  type        = string
  description = "IPv4 CIDR /24 block for the Worker Nodes subnet, providing 256 addresses (e.g., 10.0.2.0/24)"
}

variable "subnet_pods_cidr_19" {
  type        = string
  description = "IPv4 CIDR /19 block for the Native Pods subnet, providing 8,192 addresses (e.g., 10.0.32.0/19)"
}

variable "type_of_cluster" {
  type        = string
  description = "Type of cluster OKE: BASIC_CLUSTER or ENHANCED_CLUSTER"
  default     = "ENHANCED_CLUSTER"
  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.type_of_cluster)
    error_message = "The value must be 'BASIC_CLUSTER' or 'ENHANCED_CLUSTER'"
  }
}

variable "cni_type" {
  type        = string
  description = "The CNI plugin type for the cluster (e.g., FLANNEL or OCI_VCN_IP_NATIVE)"
  default     = "OCI_VCN_IP_NATIVE"

  validation {
    condition     = contains(["FLANNEL", "OCI_VCN_IP_NATIVE"], var.cni_type)
    error_message = "The CNI type must be 'FLANNEL' or 'OCI_VCN_IP_NATIVE'"
  }
}

variable "pool_size" {
  type        = number
  description = "The number of worker nodes in the node pool."
  default     = 2

  validation {
    condition     = var.pool_size >= 0
    error_message = "The pool_size must be a non-negative integer."
  }
}

variable "pool_node_shape" {
  description = "The shape of the nodes in the node pool, defining the CPU and memory architecture."
  type        = string
  default     = "VM.Standard.E6.Flex"
}

variable "pool_node_image_id" {
  description = "The OCID of the image to be used for the nodes in the node pool."
  type        = string
}

variable "ocpus" {
  description = "The number of OCPUs to be assigned to each node when using a flexible shape."
  type        = number
  default     = 2
}

variable "memory_in_gbs" {
  description = "The amount of memory in GBs to be assigned to each node when using a flexible shape."
  type        = number
  default     = 16
}

variable "kubernetes_version" {
  description = "The specific version of Kubernetes to be used for the OKE cluster control plane and worker nodes."
  type    = string
  default = "v1.34.2"
}