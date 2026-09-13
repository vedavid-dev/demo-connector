output "find_instance_command" {
  description = "Resolves the current instance name, zone, and ephemeral external IP, which change on every preemption/recreate"
  value       = module.cluster.find_instance_command
}

output "node_service_account_email" {
  description = "Identity the node runs as"
  value       = module.cluster.node_service_account_email
}
