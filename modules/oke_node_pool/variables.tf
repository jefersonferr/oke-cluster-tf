variable "compartment_id" { type = string }
variable "kubernetes_version"    { default = "v1.34.2" }
variable "oke_cluster_id" { type = string }

# Subnets
variable "node_subnet_id"     { type = string } # Workers (Nós)

variable "node_image_id" {
  type        = string
  description = "The id of the OKE node image"
}

variable "ad_number" {
  type        = number
  description = "The number of the Availability Domain (AD) to host the nodes (e.g., 1, 2, or 3)"
  default     = 1
}

variable "node_pool_name" {
  type        = string
  description = "The name of the node pool within the OKE cluster"
}

variable "node_shape" {
  type        = string
  description = "The shape of the node (VM) in the node pool. Flex shapes allow custom OCPU and Memory."
  default     = "VM.Standard.E5.Flex"
}

variable "ocpus" {
  type        = number
  description = "The number of OCPUs to be assigned to each node in the node pool"
  default     = 2
}

variable "memory_in_gbs" {
  type        = number
  description = "The amount of memory (in GBs) to be assigned to each node"
  default     = 16
}

variable "boot_volume_size_in_gbs" {
  type        = number
  description = "The size of the boot volume (in GBs) for each node in the node pool"
  default     = 50
}

variable "pod_subnet_ids" {
  type        = list(string)
  description = "A list of OCIDs for the subnets where pods will receive native VCN IP addresses"
}

variable "cni_type" {
  type        = string
  description = "The CNI plugin type for the cluster (e.g., FLANNEL or OCI_VCN_IP_NATIVE)"
  default     = "OCI_VCN_IP_NATIVE"
}

variable "size" {
  type        = number
  description = "The number of worker nodes to create in the node pool"
  default     = 2
}