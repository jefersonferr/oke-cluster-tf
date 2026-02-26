output "id" {
  value       = oci_core_network_security_group.this.id
  description = "OCID do NSG"
}

output "display_name" {
  value       = oci_core_network_security_group.this.display_name
  description = "Nome do NSG"
}
