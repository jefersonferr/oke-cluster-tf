variable "compartment_id" { type = string }
variable "vcn_id"         { type = string }
variable "cluster_name"   { default = "oke-native-cluster" }
variable "kubernetes_version"    { default = "v1.34.2" }

# Subnets
variable "endpoint_subnet_id" { type = string } # API Server

variable "service_lb_subnet_ids" {
  type        = list(string)
  description = "A list of OCIDs for the subnets where the load balancers will be created"
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

variable "is_public_ip_enabled" {
  type        = bool
  description = "Whether the Kubernetes API endpoint should be public (true) or private (false)"
  default     = true
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