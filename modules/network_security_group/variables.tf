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

variable "defined_tags" {
  description = "Defined tags"
  type        = map(string)
  default     = null
}

variable "freeform_tags" {
  description = "Freeform tags"
  type        = map(string)
  default     = null
}

variable "ingress_security_rules" {
  description = "List of ingress rules"
  type        = list(map(any))
  default     = []
}

variable "egress_security_rules" {
  description = "List of egress rules"
  type        = list(map(any))
  default     = []
}
