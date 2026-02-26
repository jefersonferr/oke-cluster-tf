variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where resource will be created"
}

variable "cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VCN"
  default     = "10.0.0.0/16"
}

variable "display_name" {
  type        = string
  description = "The user-friendly name for the VCN"
}

variable "dns_label" {
  type        = string
  description = "DNS label for the VCN (max 15 characters, alphanumeric)"
}