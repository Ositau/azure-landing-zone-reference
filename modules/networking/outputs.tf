output "vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet name => subnet ID."
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "nsg_id" {
  description = "Resource ID of the workload NSG."
  value       = azurerm_network_security_group.this.id
}
