# OCID do Node Pool
output "node_pool_id" {
  description = "O OCID do Node Pool"
  value       = oci_containerengine_node_pool.this.id
}
