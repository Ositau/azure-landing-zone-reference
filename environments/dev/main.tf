# Dev landing zone: composes the reusable modules into a complete, governed,
# secure-by-default hub network. The same root is reused per environment by
# swapping the tfvars + backend, guaranteeing identical shape across dev/test/prod.

module "naming" {
  source      = "../../modules/naming"
  org         = var.org
  workload    = var.workload
  environment = var.environment
  location    = var.location
}

locals {
  common_tags = merge(var.tags, {
    environment = var.environment
    managedBy   = "terraform"
    repo        = "azure-landing-zone-reference"
  })
}

module "governance" {
  source              = "../../modules/governance"
  resource_group_name = module.naming.names.resource_group
  location            = var.location
  log_analytics_name  = module.naming.names.log_analytics
  log_retention_days  = var.log_retention_days
  required_tags       = ["environment", "owner", "costCentre"]
  tags                = local.common_tags
}

module "networking" {
  source                     = "../../modules/networking"
  resource_group_name        = module.governance.resource_group_name
  location                   = var.location
  vnet_name                  = module.naming.names.vnet
  nsg_name                   = module.naming.names.nsg
  address_space              = var.address_space
  subnets                    = var.subnets
  log_analytics_workspace_id = module.governance.log_analytics_workspace_id
  tags                       = local.common_tags
}
