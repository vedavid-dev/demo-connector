output "instance_group" {
  description = "Self-link a caller scripts against, e.g. `gcloud compute instance-groups managed list-instances`"
  value       = google_compute_region_instance_group_manager.demo.self_link
}

output "region" {
  description = "Derived from var.zone; the group can place its instance in any zone here"
  value       = local.region
}

output "base_instance_name" {
  description = "Prefix of the running instance's actual (randomly suffixed) name"
  value       = google_compute_region_instance_group_manager.demo.base_instance_name
}

output "find_instance_command" {
  description = "Resolves the current instance name, zone, and ephemeral external IP, which change on every preemption/recreate"
  value       = "gcloud compute instance-groups managed list-instances ${google_compute_region_instance_group_manager.demo.name} --region=${local.region} --project=${var.project}"
}

output "node_service_account_email" {
  description = "Identity the node runs as"
  value       = google_service_account.node.email
}

output "node_service_account_name" {
  description = "Fully qualified name, for IAM bindings a caller attaches to the node's identity"
  value       = google_service_account.node.name
}
