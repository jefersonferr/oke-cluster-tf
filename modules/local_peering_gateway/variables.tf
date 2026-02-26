variable "compartment_id" {
  description = "The OCID of the compartment where the LPG will be created"
  type        = string
}

variable "vcn_id" {
  description = "The OCID of the VCN to which the LPG will be attached"
  type        = string
}

variable "display_name" {
  description = "A user-friendly name for the LPG"
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "Optional. The OCID of the route table to associate with the LPG"
  type        = string
  default     = null
}

variable "peer_id" {
  description = "The OCID of the peer LPG (for peering)"
  type        = string
  default     = null
}

variable "defined_tags" {
  description = "Defined tags (namespace.key: value)"
  type        = map(string)
  default     = null
}

variable "freeform_tags" {
  description = "Free-form tags (key: value)"
  type        = map(string)
  default     = null
}
