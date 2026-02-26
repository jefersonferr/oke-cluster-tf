output "route_table_id" {
  value       = oci_core_route_table.this.id
  description = "The OCID of the route table."
}
