variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where resource will be created"
}

variable "cidr_block" {}
variable "display_name" {}
variable "dns_label" {}
variable "private_subnet" { default= "false" }
variable "route_table_id" {}
variable "security_list_ids" {
  type        = list(string)
  default     = null
  description = "Defined security list ids for the subnet."
}
variable "vcn_id" {}