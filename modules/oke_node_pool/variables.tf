variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the node pool will be created"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version for the worker nodes"
  default     = "v1.34.2"
}

variable "oke_cluster_id" {
  type        = string
  description = "The OCID of the OKE cluster"
}

variable "node_subnet_id" {
  type        = string
  description = "The OCID of the subnet for worker nodes"
}

variable "node_image_id" {
  type        = string
  description = "The OCID of the image used by OKE worker nodes"
}

variable "ad_name" {
  type        = string
  description = "The Availability Domain where the worker nodes will be deployed"
}

variable "node_pool_name" {
  type        = string
  description = "The display name of the node pool"
}

variable "node_shape" {
  type        = string
  description = "The compute shape for worker nodes. Flex shapes allow custom OCPU and memory."
  default     = "VM.Standard.E5.Flex"
}

variable "ocpus" {
  type        = number
  description = "The number of OCPUs per worker node (used with Flex shapes)"
  default     = 2
}

variable "memory_in_gbs" {
  type        = number
  description = "The amount of memory in GBs per worker node (used with Flex shapes)"
  default     = 16
}

variable "boot_volume_size_in_gbs" {
  type        = number
  description = "The boot volume size in GBs for each worker node"
  default     = 50
}

variable "pod_subnet_ids" {
  type        = list(string)
  description = "A list of subnet OCIDs for native pod networking. Required for OCI_VCN_IP_NATIVE, empty for FLANNEL."
  default     = []
}

variable "cni_type" {
  type        = string
  description = "The CNI plugin type: FLANNEL or OCI_VCN_IP_NATIVE"
  default     = "OCI_VCN_IP_NATIVE"
}

variable "size" {
  type        = number
  description = "The number of worker nodes in the node pool"
  default     = 2
}