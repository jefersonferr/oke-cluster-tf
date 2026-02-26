variable "default_route_table_id" {
  type        = string
  description = "OCID of the default route table for the VCN."
}

variable "display_name" {
  type        = string
  description = "Display name for the default route table."
}

variable "route_rules" {
  type = list(object({
    network_entity_id = string
    destination       = string
    destination_type  = string
    description       = optional(string)
  }))
  description = "List of route rules to configure in the default route table."
}

variable "defined_tags" {
  type        = map(any)
  default     = null
  description = "Defined tags for the route table."
}

variable "freeform_tags" {
  type        = map(string)
  default     = null
  description = "Freeform tags for the route table."
}
