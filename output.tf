output "jump_public_ip_address" {
  description   = "The external IP address of the jump host"
  value         = yandex_compute_instance.jump_host.network_interface.0.nat_ip_address
}

output "jump_local_ip_address" {
  description = "The local IP address of jump host"
  value = yandex_compute_instance.jump_host.network_interface.0.ip_address
}

output "master_local_ip_address" {
  description = "The local IP address of master node"
  value = yandex_compute_instance.master_node[*].network_interface.0.ip_address
}

output "worker_local_ip_address" {
  description = "The local IP address of worker node"
  value = yandex_compute_instance.worker_node[*].network_interface.0.ip_address
}