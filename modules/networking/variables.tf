variable "resource_group_name" {
  description = "Resource group to deploy networking into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "vnet_name" {
  description = "Name of the hub virtual network."
  type        = string
}

variable "nsg_name" {
  description = "Name of the network security group applied to workload subnets."
  type        = string
}

variable "address_space" {
  description = "Hub VNet CIDR(s)."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnets" {
  description = "Subnets to create. Use exact names for platform subnets (GatewaySubnet, AzureFirewallSubnet, AzureBastionSubnet) where required."
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    # Workload subnets get the NSG; platform subnets (Gateway/Firewall) must not.
    associate_nsg                     = optional(bool, true)
    private_endpoint_network_policies = optional(string, "Enabled")
  }))
}

variable "log_analytics_workspace_id" {
  description = "Workspace ID for NSG flow/diagnostic logs. Empty to skip diagnostics."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
