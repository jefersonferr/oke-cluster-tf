resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_id
  display_name = var.display_name
  vcn_id = var.vcn_id
  services {
    service_id = var.service_id
  }
}