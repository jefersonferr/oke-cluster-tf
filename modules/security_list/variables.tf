variable "compartment_id" {
  type        = string
  description = "OCID of the compartment."
}

variable "vcn_id" {
  type        = string
  description = "OCID of the VCN."
}

variable "display_name" {
  type        = string
  description = "Display name for the security list."
}

# Ingress rules
variable "ingress_security_rules" {
  type = list(object({
    protocol     = string
    source       = string
    source_type  = string
    description  = optional(string)
    stateless    = optional(bool)
    tcp_min      = optional(number)
    tcp_max      = optional(number)
    udp_min      = optional(number)
    udp_max      = optional(number)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
  }))
  default     = []
  description = "List of ingress security rules."
}

# Egress rules
variable "egress_security_rules" {
  type = list(object({
    protocol         = string
    destination      = string
    destination_type = string
    description      = optional(string)
    stateless        = optional(bool)
    tcp_min          = optional(number)
    tcp_max          = optional(number)
    udp_min          = optional(number)
    udp_max          = optional(number)
    icmp_type        = optional(number)
    icmp_code        = optional(number)
  }))
  default     = []
  description = "List of egress security rules."
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