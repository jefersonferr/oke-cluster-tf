resource "oci_core_default_security_list" "this" {
  manage_default_resource_id = var.default_security_list_id
  display_name               = var.display_name

  dynamic "ingress_security_rules" {
    for_each = var.ingress_security_rules
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type
      stateless   = lookup(ingress_security_rules.value, "stateless", false)
      description = lookup(ingress_security_rules.value, "description", null)

      dynamic "tcp_options" {
        for_each = (
          contains(["6", "all"], ingress_security_rules.value.protocol) &&
          lookup(ingress_security_rules.value, "tcp_min", null) != null
        ) ? [1] : []
        content {
          min = ingress_security_rules.value.tcp_min
          max = ingress_security_rules.value.tcp_max
        }
      }

      dynamic "udp_options" {
        for_each = (
          contains(["17", "all"], ingress_security_rules.value.protocol) &&
          lookup(ingress_security_rules.value, "udp_min", null) != null
        ) ? [1] : []
        content {
          min = ingress_security_rules.value.udp_min
          max = ingress_security_rules.value.udp_max
        }
      }

      dynamic "icmp_options" {
        for_each = (
          ingress_security_rules.value.protocol == "1" &&
          lookup(ingress_security_rules.value, "icmp_type", null) != null
        ) ? [1] : []
        content {
          type = ingress_security_rules.value.icmp_type
          code = lookup(ingress_security_rules.value, "icmp_code", null)
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = var.egress_security_rules
    content {
      protocol         = egress_security_rules.value.protocol
      destination      = egress_security_rules.value.destination
      destination_type = egress_security_rules.value.destination_type
      stateless        = lookup(egress_security_rules.value, "stateless", false)
      description      = lookup(egress_security_rules.value, "description", null)

      dynamic "tcp_options" {
        for_each = (
          contains(["6", "all"], egress_security_rules.value.protocol) &&
          lookup(egress_security_rules.value, "tcp_min", null) != null
        ) ? [1] : []
        content {
          min = egress_security_rules.value.tcp_min
          max = egress_security_rules.value.tcp_max
        }
      }

      dynamic "udp_options" {
        for_each = (
          contains(["17", "all"], egress_security_rules.value.protocol) &&
          lookup(egress_security_rules.value, "udp_min", null) != null
        ) ? [1] : []
        content {
          min = egress_security_rules.value.udp_min
          max = egress_security_rules.value.udp_max
        }
      }

      dynamic "icmp_options" {
        for_each = (
          egress_security_rules.value.protocol == "1" &&
          lookup(egress_security_rules.value, "icmp_type", null) != null
        ) ? [1] : []
        content {
          type = egress_security_rules.value.icmp_type
          code = lookup(egress_security_rules.value, "icmp_code", null)
        }
      }
    }
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
