variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the subnet will be created"
}

variable "cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the subnet"
}

variable "display_name" {
  type        = string
  description = "The display name for the subnet"
}

variable "dns_label" {
  type        = string
  description = "DNS label for the subnet (max 15 characters, alphanumeric)"
}

variable "private_subnet" {
  type        = bool
  description = "Whether to prohibit public IP assignment on VNICs in this subnet"
  default     = false
}

variable "route_table_id" {
  type        = string
  description = "The OCID of the route table associated with the subnet"
}

variable "security_list_ids" {
  type        = list(string)
  description = "List of security list OCIDs associated with the subnet"
  default     = null
}

variable "vcn_id" {
  type        = string
  description = "The OCID of the VCN where the subnet will be created"
}