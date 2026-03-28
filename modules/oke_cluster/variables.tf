variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the cluster will be created"
}

variable "vcn_id" {
  type        = string
  description = "The OCID of the VCN for the cluster"
}

variable "cluster_name" {
  type        = string
  description = "The display name of the OKE cluster"
  default     = "oke-cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version for the cluster control plane"
  default     = "v1.34.2"
}

variable "endpoint_subnet_id" {
  type        = string
  description = "The OCID of the subnet for the Kubernetes API endpoint"
}

variable "service_lb_subnet_ids" {
  type        = list(string)
  description = "A list of OCIDs for the subnets where the load balancers will be created"
}

variable "services_cidr" {
  type        = string
  description = "The CIDR block for Kubernetes ClusterIP services"
  default     = "10.96.0.0/16"
}

variable "cni_type" {
  type        = string
  description = "The CNI plugin type for the cluster: FLANNEL or OCI_VCN_IP_NATIVE"
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