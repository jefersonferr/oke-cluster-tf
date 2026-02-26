output "subnet_id" {
    value = oci_core_subnet.subnet.id
}
output "subnet_cidr_block" {
    value = oci_core_subnet.subnet.cidr_block
}
output "vcn_dns_label" {
    value = oci_core_subnet.subnet.dns_label
}
output "vcn_display_name" {
    value = oci_core_subnet.subnet.display_name
}