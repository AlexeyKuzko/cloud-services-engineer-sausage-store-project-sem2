# Dev VM outputs
output "vm_dev_name" {
  description = "Name of the dev VM"
  value       = yandex_compute_instance.vm_dev.name
}

output "vm_dev_address" {
  description = "Public IP address of the dev VM"
  value       = yandex_compute_instance.vm_dev.network_interface.0.nat_ip_address
}

# Prod VM outputs
output "vm_prod_name" {
  description = "Name of the prod VM"
  value       = yandex_compute_instance.vm_prod.name
}

output "vm_prod_address" {
  description = "Public IP address of the prod VM"
  value       = yandex_compute_instance.vm_prod.network_interface.0.nat_ip_address
}

# Security Group outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = yandex_vpc_security_group.infra_sg.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = yandex_vpc_security_group.infra_sg.name
}

# Network outputs
output "vpc_network_id" {
  description = "ID of the VPC network"
  value       = yandex_vpc_network.infra_network.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = yandex_vpc_subnet.infra_subnet.id
}
