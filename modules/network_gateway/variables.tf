variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where resource will be created"
}

variable "display_name" {
  type        = string
  description = "The display name for the associated resource"
}

variable "vcn_id" {
  type        = string
  description = "The OCID of the VCN where the resource will be created"
}