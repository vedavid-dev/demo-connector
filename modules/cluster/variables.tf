variable "project" {
  description = "GCP project the demo cluster runs in"
  type        = string
}

variable "zone" {
  description = "Build zone; the region is derived from it and the managed instance group spans every zone in that region"
  type        = string
}

variable "name" {
  description = "Prefix for every resource this module creates, so two copies can share a project"
  type        = string
  default     = "vedavid-demo"
}

variable "machine_type" {
  description = "Node size the cost estimate assumes; changing it invalidates that estimate"
  type        = string
  default     = "e2-medium"
}

variable "git_repository_url" {
  description = "Public HTTPS URL Flux and the node's one-time bootstrap clone unauthenticated; point it at a fork to run your own manifests"
  type        = string
  default     = "https://github.com/vedavid-dev/demo-connector"
}

variable "flux_semver" {
  description = "Flux GitRepository semver range. A branch is deliberately not an option here — only a tag push reaches the cluster"
  type        = string
  default     = ">=0.1.0 <1.0.0"
}

variable "k3s_version" {
  description = "Pinned k3s release. Never \"stable\" — an unannounced k3s upgrade on a preemption-recovered node is not a moment to also absorb a Kubernetes version bump"
  type        = string
  default     = "v1.34.1+k3s1"
}

variable "flux_version" {
  description = "Pinned Flux CLI release, which decides the controller images installed. Bumping it requires a matching flux_sha256"
  type        = string
  default     = "2.9.5"
}

variable "flux_sha256" {
  description = "sha256 of flux_<flux_version>_linux_amd64.tar.gz, from that release's published checksums file"
  type        = string
  default     = "b853df82adfd7736f580692f9f734473d571606307139f8fd20c2a80dd1ff473"
}
