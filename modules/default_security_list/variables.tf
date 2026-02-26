variable "default_security_list_id" {
  type        = string
  description = "OCID of the default security list (from the VCN)."
}

variable "display_name" {
  type        = string
  description = "Display name for the default security list."
}

variable "ingress_security_rules" {
  type = list(object({
    protocol     = string
    source       = string
    source_type  = string
    stateless    = optional(bool)
    description  = optional(string)
    tcp_min      = optional(number)
    tcp_max      = optional(number)
    udp_min      = optional(number)
    udp_max      = optional(number)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
  }))
  default     = []
}

variable "egress_security_rules" {
  type = list(object({
    protocol         = string
    destination      = string
    destination_type = string
    stateless        = optional(bool)
    description      = optional(string)
    tcp_min          = optional(number)
    tcp_max          = optional(number)
    udp_min          = optional(number)
    udp_max          = optional(number)
    icmp_type        = optional(number)
    icmp_code        = optional(number)
  }))
  default     = []
}

variable "defined_tags" {
  type        = map(string)
  default     = null
  description = "Defined tags for the resource."
}

variable "freeform_tags" {
  type        = map(string)
  default     = null
  description = "Freeform tags for the resource."
}
variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where the VCN and its default security list exist."
}