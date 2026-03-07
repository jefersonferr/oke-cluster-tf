data "oci_core_services" "all_services" {

  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }

}

locals {

  resolved_service_id = var.service_id != null ? var.service_id : data.oci_core_services.all_services.services[0].id

}

resource "oci_core_service_gateway" "service_gateway" {

  compartment_id = var.compartment_id
  display_name   = var.display_name
  vcn_id         = var.vcn_id

  services {
    service_id = local.resolved_service_id
  }

}