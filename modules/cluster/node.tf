resource "google_service_account" "node" {
  project      = var.project
  account_id   = "${var.name}-node"
  display_name = "The demo cluster's single node"
}

resource "google_project_iam_member" "node_writes_telemetry" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.node.email}"
}
