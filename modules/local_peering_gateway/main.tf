resource "oci_core_local_peering_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = var.display_name

  route_table_id = var.route_table_id
  peer_id        = var.peer_id

  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
}
