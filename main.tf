module "cluster" {
  source = "./modules/cluster"

  project            = var.project
  zone               = var.zone
  name               = var.name
  machine_type       = var.machine_type
  git_repository_url = var.git_repository_url

  depends_on = [google_project_service.required]
}
