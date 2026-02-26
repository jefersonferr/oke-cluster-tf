resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id    = var.compartment_id
  display_name      = var.display_name
  enabled           = "true"
  vcn_id            = var.vcn_id
}