# Centralised, CAF-aligned resource naming. One source of truth so every resource
# across every environment is named consistently and drift-free.
# Pattern: <type>-<org>-<workload>-<env>-<region>-<instance>
# Storage/keyvault have no separators and tighter length limits, handled separately.

locals {
  # Microsoft CAF region short codes (extend as needed).
  region_short = {
    uksouth     = "uks"
    ukwest      = "ukw"
    westeurope  = "weu"
    northeurope = "neu"
    eastus      = "eus"
    eastus2     = "eus2"
  }
  loc = lookup(local.region_short, var.location, substr(replace(var.location, " ", ""), 0, 3))

  base    = "${var.org}-${var.workload}-${var.environment}-${local.loc}-${var.instance}"
  compact = lower(replace("${var.org}${var.workload}${var.environment}${local.loc}${var.instance}", "-", ""))
}

# Type-prefixed names for the resources this reference provisions.
locals {
  names = {
    resource_group = "rg-${local.base}"
    vnet           = "vnet-${local.base}"
    nsg            = "nsg-${local.base}"
    route_table    = "rt-${local.base}"
    firewall       = "afw-${local.base}"
    log_analytics  = "log-${local.base}"
    # Globally-unique, no-dash, length-capped resources.
    storage_account = substr("st${local.compact}", 0, 24)
    key_vault       = substr("kv-${local.base}", 0, 24)
  }
}
