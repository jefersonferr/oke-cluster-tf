output "vcn_id" {
  value = oci_core_vcn.vcn.id
}
output "vcn_cidr_block" {
  value = oci_core_vcn.vcn.cidr_block
}
output "vcn_dns_label" {
  value = oci_core_vcn.vcn.dns_label
}
output "vcn_display_name" {
  value = oci_core_vcn.vcn.display_name
}
output "vcn_default_route_table_id" {
  value = oci_core_vcn.vcn.default_route_table_id
}
output "vcn_default_security_list_id" {
  value = oci_core_vcn.vcn.default_security_list_id
}