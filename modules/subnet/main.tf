resource "oci_core_subnet" "subnet" {
  cidr_block                 = var.cidr_block
  compartment_id             = var.compartment_id
  display_name               = var.display_name
  dns_label                  = var.dns_label
  prohibit_public_ip_on_vnic = var.private_subnet
  route_table_id             = var.route_table_id
  security_list_ids          = var.security_list_ids
  vcn_id                     = var.vcn_id
}