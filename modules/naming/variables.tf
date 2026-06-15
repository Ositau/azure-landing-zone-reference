variable "org" {
  description = "Short organisation/prefix code, e.g. 'ctso'."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{2,6}$", var.org))
    error_message = "org must be 2-6 lowercase alphanumeric characters."
  }
}

variable "workload" {
  description = "Workload or application short name, e.g. 'platform', 'web', 'data'."
  type        = string
}

variable "environment" {
  description = "Environment short code: dev | test | stg | prod."
  type        = string
  validation {
    condition     = contains(["dev", "test", "stg", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, stg, prod."
  }
}

variable "location" {
  description = "Azure region, e.g. 'uksouth'."
  type        = string
}

variable "instance" {
  description = "Zero-padded instance number to keep names unique, e.g. '001'."
  type        = string
  default     = "001"
}
