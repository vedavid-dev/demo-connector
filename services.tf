locals {
  region = join("-", slice(split("-", var.zone), 0, length(split("-", var.zone)) - 1))
}

resource "google_project_service" "required" {
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ])

  project = var.project
  service = each.value

  # Turning an API off tears down what depends on it.
  disable_on_destroy = false
}
