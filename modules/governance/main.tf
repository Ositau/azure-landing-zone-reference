resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Governance guardrail: require a standard set of tags on every resource in the RG.
# Demonstrates policy-as-code; "Deny" effect blocks non-compliant deployments.
resource "azurerm_policy_definition" "require_tags" {
  name         = "require-standard-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require standard tags on resources"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        for tag in var.required_tags : {
          field  = "tags['${tag}']"
          exists = "false"
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "require_tags" {
  name                 = "require-standard-tags"
  resource_group_id    = azurerm_resource_group.this.id
  policy_definition_id = azurerm_policy_definition.require_tags.id
  description          = "Blocks resource creation that is missing mandatory governance tags."
}
