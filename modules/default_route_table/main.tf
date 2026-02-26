resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = var.default_route_table_id
  display_name               = var.display_name

  dynamic "route_rules" {
    for_each = var.route_rules
    content {
      network_entity_id = route_rules.value.network_entity_id
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      description       = lookup(route_rules.value, "description", null)
    }
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
