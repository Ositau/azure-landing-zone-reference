org           = "ctso"
workload      = "platform"
environment   = "dev"
location      = "uksouth"
address_space = ["10.10.0.0/16"]

# Platform subnets use Azure's required exact names and get NO workload NSG.
subnets = {
  "AzureFirewallSubnet" = {
    address_prefixes = ["10.10.0.0/26"]
    associate_nsg    = false
  }
  "GatewaySubnet" = {
    address_prefixes = ["10.10.0.64/27"]
    associate_nsg    = false
  }
  "snet-shared" = {
    address_prefixes  = ["10.10.1.0/24"]
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }
  "snet-privatelink" = {
    address_prefixes                  = ["10.10.2.0/24"]
    private_endpoint_network_policies = "Disabled"
  }
}

tags = {
  owner      = "platform-team"
  costCentre = "IT-CLOUD-001"
}
