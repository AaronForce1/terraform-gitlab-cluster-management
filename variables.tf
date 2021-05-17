variable "gitlab_configuration" {
  type = object({
    name                          = string
    gitlab_host_url               = string
    token                         = string
    group                         = string
    cluster_environment_scope     = string
    cluster_management_project_id = string
  })
  sensitive   = true
  description = "Gitlab Configuration Object: Token, Gitlab Group for Kubernetes Cluster integration, and environment scope."
}

variable "cluster_domain" {
  description = "Optional Cluster Domain to be used as a base mapping for Gitlab Environments"
  default     = "example.com"
}