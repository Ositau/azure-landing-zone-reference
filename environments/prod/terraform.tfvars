org                = "ctso"
workload           = "platform"
environment        = "prod"
location           = "uksouth"
log_retention_days = 90
address_space      = ["10.20.0.0/16"]

subnets = {
  "AzureFirewallSubnet" = {
    address_prefixes = ["10.20.0.0/26"]
    associate_nsg    = false
  }
  "GatewaySubnet" = {
    address_prefixes = ["10.20.0.64/27"]
    associate_nsg    = false
  }
  "snet-shared" = {
    address_prefixes  = ["10.20.1.0/24"]
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
  }
  "snet-privatelink" = {
    address_prefixes                  = ["10.20.2.0/24"]
    private_endpoint_network_policies = "Disabled"
  }
}

tags = {
  owner      = "platform-team"
  costCentre = "IT-CLOUD-001"
}
