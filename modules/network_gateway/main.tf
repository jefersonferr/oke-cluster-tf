resource "oci_core_nat_gateway" "nat_gateway" {
    block_traffic  = "false"
    compartment_id = var.compartment_id
    display_name = var.display_name
    vcn_id = var.vcn_id
}