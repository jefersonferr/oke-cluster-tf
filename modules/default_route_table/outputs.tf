output "default_route_table_id" {
  value       = oci_core_default_route_table.this.id
  description = "The OCID of the default route table."
}
