variable "resource_group_name" {
  description = "Name of the platform resource group to create."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

variable "log_retention_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}

variable "required_tags" {
  description = "Tag keys that must be present on resources (enforced via Azure Policy)."
  type        = list(string)
  default     = ["environment", "owner", "costCentre"]
}

variable "tags" {
  description = "Tags applied to created resources."
  type        = map(string)
  default     = {}
}
