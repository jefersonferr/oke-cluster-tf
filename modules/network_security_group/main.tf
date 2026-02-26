resource "oci_core_network_security_group" "this" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = var.display_name

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_core_network_security_group_security_rule" "ingress" {
  for_each                  = { for idx, rule in var.ingress_security_rules : idx => rule }
  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "INGRESS"
  protocol                  = each.value.protocol
  source                    = each.value.source
  source_type               = each.value.source_type
  stateless                 = lookup(each.value, "stateless", false)
  description               = lookup(each.value, "description", null)

  dynamic "tcp_options" {
    for_each = (
      contains(["6", "all"], each.value.protocol) &&
      lookup(each.value, "tcp_min", null) != null
    ) ? [1] : []
    content {
      destination_port_range {
        min = each.value.tcp_min
        max = each.value.tcp_max
      }
    }
  }

  dynamic "udp_options" {
    for_each = (
      contains(["17", "all"], each.value.protocol) &&
      lookup(each.value, "udp_min", null) != null
    ) ? [1] : []
    content {
      destination_port_range {
        min = each.value.udp_min
        max = each.value.udp_max
      }
    }
  }

  dynamic "icmp_options" {
    for_each = (
      each.value.protocol == "1" &&
      lookup(each.value, "icmp_type", null) != null
    ) ? [1] : []
    content {
      type = each.value.icmp_type
      code = lookup(each.value, "icmp_code", null)
    }
  }
}

resource "oci_core_network_security_group_security_rule" "egress" {
  for_each                  = { for idx, rule in var.egress_security_rules : idx => rule }
  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "EGRESS"
  protocol                  = each.value.protocol
  destination               = each.value.destination
  destination_type          = each.value.destination_type
  stateless                 = lookup(each.value, "stateless", false)
  description               = lookup(each.value, "description", null)

  dynamic "tcp_options" {
    for_each = (
      contains(["6", "all"], each.value.protocol) &&
      lookup(each.value, "tcp_min", null) != null
    ) ? [1] : []
    content {
      destination_port_range {
        min = each.value.tcp_min
        max = each.value.tcp_max
      }
    }
  }

  dynamic "udp_options" {
    for_each = (
      contains(["17", "all"], each.value.protocol) &&
      lookup(each.value, "udp_min", null) != null
    ) ? [1] : []
    content {
      destination_port_range {
        min = each.value.udp_min
        max = each.value.udp_max
      }
    }
  }

  dynamic "icmp_options" {
    for_each = (
      each.value.protocol == "1" &&
      lookup(each.value, "icmp_type", null) != null
    ) ? [1] : []
    content {
      type = each.value.icmp_type
      code = lookup(each.value, "icmp_code", null)
    }
  }
}
