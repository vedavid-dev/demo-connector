variable "project" {
  description = "Existing GCP project to build the demo cluster in; this configuration never creates one or touches billing"
  type        = string
}

variable "zone" {
  description = "Build zone; the region is derived from it"
  type        = string
  default     = "europe-west1-b"
}

variable "name" {
  description = "Prefix for every resource created here"
  type        = string
  default     = "vedavid-demo"
}

variable "machine_type" {
  description = "Node size the cost estimate in README.md assumes"
  type        = string
  default     = "e2-medium"
}

variable "git_repository_url" {
  description = "Repository Flux syncs the cluster from; point it at a fork to run your own manifests"
  type        = string
  default     = "https://github.com/vedavid-dev/demo-connector"
}
