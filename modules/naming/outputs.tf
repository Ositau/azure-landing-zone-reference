output "names" {
  description = "Map of standardised resource names keyed by resource type."
  value       = local.names
}

output "region_short" {
  description = "Resolved short code for the region."
  value       = local.loc
}
