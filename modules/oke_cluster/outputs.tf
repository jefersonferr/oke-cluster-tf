output "cluster_id" {
  description = "Cluster OKE id"
  value       = oci_containerengine_cluster.this.id
}