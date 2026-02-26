resource "oci_core_vcn" "vcn" {
    compartment_id = var.compartment_id
    cidr_block = var.cidr_block
    display_name = var.display_name
    dns_label = var.dns_label
}