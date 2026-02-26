variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the route table will be created."
}

variable "vcn_id" {
  type        = string
  description = "OCID of the VCN to associate with the route table."
}

variable "display_name" {
  type        = string
  description = "Name of the route table."
}

variable "route_rules" {
  type = list(object({
    network_entity_id = string
    destination       = string
    destination_type  = string
    description       = optional(string)
  }))
  description = "List of route rules to apply."
}

variable "defined_tags" {
  type        = map(any)
  default     = null
  description = "Defined tags."
}

variable "freeform_tags" {
  type        = map(string)
  default     = null
  description = "Freeform tags."
}
