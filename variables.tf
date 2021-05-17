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

variable "kubernetes_configuration" {
  type = object({
    cluster_name                       = string
    kubernetes_api_url                 = string
    cluster_certificate_authority_data = string
    token                              = string
  })
  sensitive = true
  description = "Kubernetes configuration required to bind the cluster into gitlab with management capabilities"
}

variable "cluster_domain" {
  description = "Optional Cluster Domain to be used as a base mapping for Gitlab Environments"
  default     = "example.com"
}