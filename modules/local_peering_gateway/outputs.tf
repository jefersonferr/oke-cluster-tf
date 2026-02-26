output "local_peering_gateway_id" {
  description = "The OCID of the Local Peering Gateway"
  value       = oci_core_local_peering_gateway.this.id
}

output "local_peering_gateway_display_name" {
  description = "The display name of the Local Peering Gateway"
  value       = oci_core_local_peering_gateway.this.display_name
}
