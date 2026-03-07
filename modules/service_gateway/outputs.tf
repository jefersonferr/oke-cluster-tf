output "service_gateway_id" {
    value = oci_core_service_gateway.service_gateway.id
}
output "service_gateway_display_name" {
    value = oci_core_service_gateway.service_gateway.display_name
}
output "all_region_services" {
  value = data.oci_core_services.all_services.services[0].name
}
