# =============================================================================
# Outputs
# =============================================================================

output "scenario_description" {
  description = "The Oracle documentation example that matches the selected configuration"
  value = format("Example %s — %s CNI, %s Kubernetes API Endpoint",
    var.cni_type == "FLANNEL" && var.is_api_endpoint_public      ? "1" :
    var.cni_type == "FLANNEL" && !var.is_api_endpoint_public     ? "2" :
    var.cni_type == "OCI_VCN_IP_NATIVE" && var.is_api_endpoint_public  ? "3" : "4",
    var.cni_type == "FLANNEL" ? "Flannel" : "OCI VCN-Native",
    var.is_api_endpoint_public ? "Public" : "Private"
  )
}

output "cluster_id" {
  description = "The OCID of the OKE cluster"
  value       = module.oke-cluster.cluster_id
}

output "vcn_id" {
  description = "The OCID of the VCN"
  value       = module.vcn.vcn_id
}

output "subnet_api_endpoint_id" {
  description = "The OCID of the API endpoint subnet"
  value       = module.subnet-api-endpoint.subnet_id
}

output "subnet_nodes_id" {
  description = "The OCID of the worker nodes subnet"
  value       = module.subnet-nodes.subnet_id
}

output "subnet_lb_id" {
  description = "The OCID of the load balancer subnet"
  value       = module.subnet-lb.subnet_id
}

output "subnet_pods_id" {
  description = "The OCID of the pods subnet (only when using OCI VCN-Native CNI)"
  value       = var.cni_type == "OCI_VCN_IP_NATIVE" ? module.subnet-pods[0].subnet_id : null
}
