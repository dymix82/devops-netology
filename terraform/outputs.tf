
output "public-subnet-id-default" {
  value = [for instance in yandex_compute_instance.default: instance.network_interface[0].subnet_id]
}

output "private-ip-for-compute-instance-default" {
  value = [for instance in yandex_compute_instance.default: instance.network_interface[0].ip_address]
}
output "public-ip-for-compute-instance-default" {
  value = [for instance in yandex_compute_instance.default: instance.network_interface[0].nat_ip_address]
}