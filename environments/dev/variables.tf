variable "org" {
  type    = string
  default = "ctso"
}

variable "workload" {
  type    = string
  default = "platform"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "subnets" {
  type = map(object({
    address_prefixes                  = list(string)
    service_endpoints                 = optional(list(string), [])
    associate_nsg                     = optional(bool, true)
    private_endpoint_network_policies = optional(string, "Enabled")
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
